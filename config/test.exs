use Mix.Config

config :steam_bot, SteamBot.Repo,
       database: "steam_bot_test",
       username: "postgres",
       password: "docker",
       hostname: "localhost",
       pool: Ecto.Adapters.SQL.Sandbox

