defmodule AddTest do
  use SteamBot.RepoCase
  use ExUnit.Case

  import Mox

  setup :verify_on_exit!

  test "gets help if no arguments are applied" do
    string_length =
      SteamBot.Handler.Add.ask()
      |> String.length()

    assert string_length > 0
  end

  test "can add a user" do
    SteamBot.SteamMock
    |> expect(:get_user, fn _ ->
      %{
        "steamid" => "random_steam_id",
        "personaname" => "random_steam_name"
      }
    end)

    {:error, :index_error, _} =
      SteamBot.Handler.Add.ask(
        {:ok,
         %{
           user: %{
             id: "random_discord_id",
             username: "random_discord_name"
           }
         }},
        456_765_456
      )

    user = List.first(SteamBot.Query.get_all_users())

    assert user.discord_name == "random_discord_name"
    assert user.discord_id == "random_discord_id"
    assert user.steam_id == "random_steam_id"
    assert user.steam_name == "random_steam_name"
  end
end
