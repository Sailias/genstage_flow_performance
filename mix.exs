defmodule GenstageFlowTalk.Mixfile do
  use Mix.Project

  def project do
    [
      app: :genstage_flow_talk,
      version: "0.1.0",
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {
        GenstageFlowTalk, []
      },
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:gen_stage, "~> 0.11"},
      {:flow, "~> 0.11"}
    ]
  end
end
