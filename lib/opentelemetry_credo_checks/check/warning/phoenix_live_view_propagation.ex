defmodule OpentelemetryCredoChecks.Check.Warning.PhoenixLiveViewProcessPropagation do
  @moduledoc false

  use Credo.Check,
    run_on_all: true,
    category: :warning,
    base_priority: :high,
    param_defaults: [
      files: %{excluded: ["test/**/*_test.exs", "apps/**/test/**/*_test.exs"]}
    ],
    explanations: [
      check: """
      OpenTelemetry must propagate context to all Phoenix LiveView async processes.

      All Phenix.LiveView async macro calls should be replaced with calls to `OpentelemetryPhoenixLiveViewProcessPropagator.LiveView` async macros.
      """
    ]

  @phoenix_liveview_async [
    :start_async,
    :assign_async
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

    aliased_process_propagator? =
      "OpentelemetryPhoenixLiveViewProcessPropagator.LiveView" in aliases

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
         {fn_name, meta, _} = ast,
         issues,
         issue_meta,
         _aliased_process_propagator?
       )
       when fn_name in @phoenix_liveview_async do
    {ast, [issue_for(issue_meta, meta, fn_name) | issues]}
  end

  defp find_issues(
         {:|>, _, [_, {fn_name, meta, nil}]} = ast,
         issues,
         issue_meta,
         _aliased_process_propagator?
       )
       when fn_name in @phoenix_liveview_async do
    {ast, [issue_for(issue_meta, meta, fn_name) | issues]}
  end

  defp find_issues(ast, issues, _issue_meta, __aliased_process_propagator?) do
    {ast, issues}
  end

  defp issue_for(issue_meta, meta, trigger) when trigger in @phoenix_liveview_async do
    format_issue(
      issue_meta,
      message:
        "There should be no calls to `#{trigger}`, `OpentelemetryPhoenixLiveViewProcessPropagator.LiveView.#{trigger}` must be used instead.",
      trigger: trigger,
      line_no: meta[:line],
      column: meta[:column]
    )
  end
end
