defmodule Dummy.MixProject do
  use Mix.Project

  def project() do
    [
      app: :dummy,
      version: "1.0.0",
      deps: deps()
    ]
  end

  defp deps() do
    [
      {:a, "~> 1.0"}
    ]
  end
end
