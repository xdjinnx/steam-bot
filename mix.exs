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
      extra_applications: [:logger, :sqlite_ecto2, :ecto],
      mod: {SteamBot.Application, []}
    ]
  end

  defp deps do
    [
      {:alchemy, "~> 0.6.4", hex: :discord_alchemy},
      {:sqlite_ecto2, "~> 2.2"},
      {:poison, "~> 4.0", override: true},
      {:steam_ex, "~> 0.2.0-alpha"}
    ]
  end
end
