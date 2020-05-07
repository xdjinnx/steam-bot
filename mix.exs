defmodule SteamBot.MixProject do
  use Mix.Project

  def project do
    [
      app: :steam_bot,
      version: "0.1.0",
      elixir: "~> 1.8",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases()
    ]
  end

  def application do
    [
      extra_applications: [:logger, :ecto],
      mod: {SteamBot.Application, []}
    ]
  end

  defp deps do
    [
      {:alchemy, "~> 0.6.4", hex: :discord_alchemy},
      {:ecto_sql, "~> 3.0"},
      {:postgrex, ">= 0.0.0"},
      {:steam_ex, "~> 0.2.0-alpha"},
      {:jason, "~> 1.2"},
      {:tesla, "~> 1.3.0"},
      {:hackney, "~> 1.15.2"},
      {:mox, "~> 0.5", only: :test}
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp aliases do
    [
      test: ["ecto.create --quiet", "ecto.migrate", "test"]
    ]
  end
end
