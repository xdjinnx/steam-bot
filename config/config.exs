use Mix.Config

config :tesla, adapter: Tesla.Adapter.Hackney

config :steam_bot, call_prefix: "!dev_"
config :steam_bot, steam_key: "8C1444D72335D5A78A543DBB1CDE6A91"
config :steam_bot, discord_key: "NzAyNzg3NzQxNTY5NTE1NjQx.XqNg6A.p5ddnFdp3X24bh1qJk6uF9M7ByI"

config :steam_bot, ecto_repos: [SteamBot.Repo]

import_config "#{Mix.env()}.exs"

