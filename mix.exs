defmodule MixDepsAdd.MixProject do
  use Mix.Project

  def project do
    [
      app: :mix_deps_add,
      version: "0.1.0",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps() do
    [
      {:hex_core, "~> 0.6.10"},
      {:fix, github: "wojtekmach/fix"}
    ]
  end
end
