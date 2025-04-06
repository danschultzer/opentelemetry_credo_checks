defmodule OpentelemetryCredoChecks.Check.Warning.TaskProcessPropagation do
  use Credo.Check,
    run_on_all: true,
    category: :warning,
    base_priority: :high,
    explanations: [
      check: """
      OpenTelemetry must propagate context to all Task processes.

      All calls to Task module should be replaced with calls to OpentelemetryProcessPropagator.Task.
      """
    ]

  def run(%SourceFile{} = source_file, params) do
    issue_meta = IssueMeta.for(source_file, params)

    Credo.Code.prewalk(source_file, &traverse(&1, &2, issue_meta))
  end

  defp traverse(
         {:defmodule, _, _} = ast,
         issues,
         issue_meta
       ) do
    aliases = Credo.Code.Module.aliases(ast)
    aliased_process_propagator? = "OpentelemetryProcessPropagator.Task" in aliases

    new_issues =
      Credo.Code.prewalk(
        ast,
        &find_issues(
          &1,
          &2,
          issue_meta,
          aliased_process_propagator?
        )
      )

    {ast, issues ++ new_issues}
  end

  defp traverse(
         ast,
         issues,
         _issue_meta
       ) do
    {ast, issues}
  end

  defp find_issues(
         {{:., _meta, [{:__aliases__, meta, [:Task]}, fn_name]}, _, _} = ast,
         issues,
         issue_meta,
         false
       ) do
    {ast, [issue_for(issue_meta, meta, "Task.#{fn_name}") | issues]}
  end

  defp find_issues(ast, issues, _issue_meta, __aliased_process_propagator?) do
    {ast, issues}
  end

  defp issue_for(issue_meta, meta, "Task." <> _ = trigger) do
    format_issue(
      issue_meta,
      message:
        "There should be no direct calls to `Task`, alias `OpentelemetryProcessPropagator.Task`.",
      trigger: trigger,
      line_no: meta[:line],
      column: meta[:column]
    )
  end
end
