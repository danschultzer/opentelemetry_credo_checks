defmodule OpentelemetryCredoChecks.Check.Warning.TaskProcessPropagationTest do
  use Credo.Test.Case

  @described_check OpentelemetryCredoChecks.Check.Warning.TaskProcessPropagation

  #
  # cases NOT raising issues
  #
  test "when OpentelemetryProcessPropagator.Task module is used" do
    """
    defmodule MyModule do
      alias OpentelemetryProcessPropagator.Task

      def my_function do
        task = Task.async(fn -> IO.puts("Hello") end)

        Task.await(task)
      end
    end
    """
    |> to_source_file()
    |> run_check(@described_check)
    |> refute_issues()
  end

  #
  # cases raising issues
  #
  test "when Task module is used" do
    """
    defmodule MyModule do
      def my_function do
        task = Task.async(fn -> IO.puts("Hello") end)

        Task.await(task)
      end
    end
    """
    |> to_source_file()
    |> run_check(@described_check)
    |> assert_issues()
  end
end
