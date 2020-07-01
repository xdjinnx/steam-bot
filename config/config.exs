use Mix.Config

config :tesla, adapter: Tesla.Adapter.Hackney

config :steam_bot, call_prefix: "!dev_"
config :steam_bot, steam_key: "" # TODO: Missing key
config :steam_bot, discord_key: "" # TODO: Missing key

config :steam_bot, ecto_repos: [SteamBot.Repo]

import_config "#{Mix.env()}.exs"

