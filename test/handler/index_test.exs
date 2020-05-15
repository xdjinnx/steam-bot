defmodule Handler.IndexTest do
  use SteamBot.RepoCase
  use ExUnit.Case

  import Mox

  setup :verify_on_exit!

  test "index no games" do
    SteamBot.Repo.insert(get_user())

    SteamBot.SteamMock
    |> expect(:get_owned_games, fn _ ->
      []
    end)

    SteamBot.Handler.Index.ask("123")
  end

  test "index games" do
    SteamBot.Repo.insert(get_user())

    SteamBot.SteamMock
    |> expect(:get_owned_games, fn _ ->
      [
        %{
          "appid" => 1234,
          "name" => "Test game"
        }
      ]
    end)

    SteamBot.Handler.Index.ask("123")
  end

  def get_user(),
    do: %SteamBot.Schema.User{
      steam_id: "123",
      discord_id: "123",
      steam_name: "steam_name",
      discord_name: "discord_name"
    }
end
