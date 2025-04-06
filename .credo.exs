%{
  configs: [
    %{
      name: "default",
      checks: [
        {Credo.Check.Readability.ModuleDoc, ignore_names: [~r/^OpentelemetryCredoChecks\.Check\.\w+\.\w+$/]}
      ]
    }
  ]
}
