defmodule OpentelemetryCredoChecks.Check.Warning.PhoenixLiveViewProcessPropagationTest do
  use Credo.Test.Case

  @described_check OpentelemetryCredoChecks.Check.Warning.PhoenixLiveViewProcessPropagation

  #
  # cases NOT raising issues
  #
  test "when OpentelemetryPhoenix.LiveView.assign_async/OpentelemetryPhoenix.start_async is used" do
    """
    defmodule MyAppWeb.ResourceLive.Index do
      use MyAppWeb, :live_view

      def handle_params(params, _uri, socket) do
        socket = OpentelemetryPhoenix.LiveView.start_async(socket, :my_task, fn -> {:ok, do_something()} end)

        {:noreply,
          socket
          |> OpentelemetryPhoenix.LiveView.assign_async(:my_other_task, fn -> {:ok, do_something()} end)}
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
  test "when assign_async/start_async is used" do
    """
    defmodule MyAppWeb.ResourceLive.Index do
      use MyAppWeb, :live_view

      def handle_params(params, _uri, socket) do
        socket = start_async(socket, :my_task, fn -> {:ok, do_something()} end)

        {:noreply,
          socket
          |> assign_async(:my_other_task, fn -> {:ok, do_something()} end)}
      end
    end
    """
    |> to_source_file()
    |> run_check(@described_check)
    |> assert_issues()
  end
end
