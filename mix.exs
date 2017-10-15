defmodule EsEh.Mixfile do
  use Mix.Project

  def project do
    [
      app: :es_eh,
      version: "0.1.0",
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {EsEh.Application, []}
    ]
  end

  defp deps do
    [
      {:commanded, "~> 0.14.0"},
      {:commanded_eventstore_adapter, "~> 0.2"},
    ]
  end
end
