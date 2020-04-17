defmodule SteamBot.MixProject do
  use Mix.Project

  def project do
    [
      app: :steam_bot,
      version: "0.1.0",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      deps: deps()
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
      {:blocking_queue, "~> 1.0"}
    ]
  end
end
