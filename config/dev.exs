use Mix.Config

config :steam_bot, SteamBot.Repo,
       database: "steam_bot_repo",
       username: "postgres",
       password: "docker",
       hostname: "localhost"