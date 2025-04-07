# OpentelemetryCredoChecks

[![Github CI](https://github.com/open-telemetrex/opentelemetry_credo_checks/workflows/CI/badge.svg)](https://github.com/open-telemetrex/opentelemetry_credo_checks/actions?query=workflow%3ACI)
[![hex.pm](https://img.shields.io/hexpm/v/opentelemetry_credo_checks.svg)](https://hex.pm/packages/opentelemetry_credo_checks)

<!-- MDOC !-->

Credo checks for OpenTelemetry.

Includes checks for: 

- `OpentelemetryCredoChecks.Check.Warning.TaskProcessPropagation`
- `OpentelemetryCredoChecks.Check.Warning.PhoenixLiveViewProcessPropagation`

<!-- MDOC !-->

## Installation

Add `opentelemetry_credo_checks` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:opentelemetry_credo_checks, "~> 0.1", only: [:dev, :test], runtime: false}
  ]
end
```

## Usage

Add the checks to `.credo.exs`:

```elixir
%{
  configs: [
    %{
      name: "default",
      checks: [
        {OpentelemetryCredoChecks.Check.Warning.TaskProcessPropagation, []}
      ]
    }
  ]
}
```

### Ensure process propagation for `Task` processes

This check will raise an issue if there is missing process propagation for Task async calls.

```elixir
{OpentelemetryCredoChecks.Check.Warning.TaskProcessPropagation, []}
```

Suppose you have a `MyApp.MyModule` module:

```elixir
$ mix credo

┃  Warnings - please take a look
┃
┃ [W] ↗ There should be no direct calls to `Task`, alias `OpentelemetryProcessPropagator.Task`.
┃       lib/my_app/my_module.ex:1:1 #(MyApp.MyModule)
```

### Ensure process propagation for `Phoenix.LiveView` async assigns

This check will raise an issue if there is missing process propagation for Phoenix LiveView async assigns.

```elixir
{OpentelemetryCredoChecks.Check.Warning.PhoenixLiveViewProcessPropagation, []}
```

Suppose you have a `MyAppWeb.MyLiveView` module:

```elixir
$ mix credo

┃  Warnings - please take a look
┃
┃ [W] ↗ There should be no calls to `assign_async`, `OpentelemetryPhoenixLiveViewProcessPropagator.LiveView.assign_async` must be used instead.
┃       lib/my_app_web/my_live_view.ex:1:1 #(MyAppWeb.MyLiveView)
```

<!-- MDOC !-->

## LICENSE

(The MIT License)

Copyright (c) 2025 Dan Schultzer & the Contributors

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the 'Software'), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
