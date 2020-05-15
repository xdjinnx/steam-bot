children = [
  SteamBot.Repo,
  SteamBot.IndexQueue,
  Mox.Server
]

opts = [strategy: :one_for_one, name: SteamBot.Supervisor]
Supervisor.start_link(children, opts)

ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(SteamBot.Repo, :manual)

Mox.defmock(SteamBot.SteamMock, for: SteamBot.Steam)
Mox.defmock(SteamBot.DiscordMock, for: SteamBot.Discord)
