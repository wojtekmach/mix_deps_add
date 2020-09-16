defmodule Mix.Tasks.Deps.AddTest do
  use ExUnit.Case, async: true

  test "hex" do
    Mix.Project.in_project(:dummy, "test/fixtures/dummy", fn _ ->
      Mix.Task.run("deps.add", ["hex", "ex_doc", "--dry-run"])
    end)
  end
end
