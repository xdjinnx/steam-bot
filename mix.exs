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
      extra_applications: [:logger],
      mod: {SteamBot.Application, []}
    ]
  end

  defp deps do
    [
      {:alchemy, "~> 0.6.4", hex: :discord_alchemy}
    ]
  end
end
