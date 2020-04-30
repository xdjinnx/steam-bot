defmodule SteamBot.RepoCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      alias SteamBot.Repo

      import Ecto
      import Ecto.Query
      import SteamBot.RepoCase

      # and any other stuff
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(SteamBot.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(SteamBot.Repo, {:shared, self()})
    end

    :ok
  end
end
