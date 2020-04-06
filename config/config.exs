# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

config :steam_bot, steam_key: "8C1444D72335D5A78A543DBB1CDE6A91"
config :steam_bot, discord_key: "NjgwODk0NTIzODQwNTI4NDA3.XlHRTg.5vGd1X-3o4-3SHK8bvoIQsnSwwQ"

config :tesla, adapter: Tesla.Adapter.Hackney

config :steam_bot,
  ecto_repos: [Repo]

config :steam_bot, Repo,
  adapter: Sqlite.Ecto2,
  database: "bot.sqlite3"


# It is also possible to import configuration files, relative to this
# directory. For example, you can emulate configuration per environment
# by uncommenting the line below and defining dev.exs, test.exs and such.
# Configuration from the imported file will override the ones defined
# here (which is why it is important to import them last).
#
#     import_config "#{Mix.env()}.exs"
