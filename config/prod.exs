use Mix.Config

config :steam_bot, discord_key: "NjgwODk0NTIzODQwNTI4NDA3.XqNgyA.C2gR3yBFPnWSiVPqL5w9pe3Nk20"

config :steam_bot, SteamBot.Repo,
       database: "steam_bot_repo",
       username: "postgres",
       password: "docker",
       hostname: "postgres"