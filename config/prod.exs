use Mix.Config

config :steam_bot, call_prefix: "!"
config :steam_bot, discord_key: "" # TODO: Missing key

config :steam_bot, SteamBot.Repo,
       database: "steam_bot_repo",
       username: "postgres",
       password: "docker",
       hostname: "postgres"