ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(SteamBot.Repo, :manual)

Mox.defmock(SteamBot.SteamMock, for: SteamBot.Steam)
