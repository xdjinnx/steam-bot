defmodule BotUsersTest do
  use SteamBot.RepoCase
  use ExUnit.Case

  test "returns users from database" do
    SteamBot.Repo.insert(get_user())

    users = SteamBot.Handler.BotUsers.ask()
    assert Enum.count(users) == 1
  end

  test "parse users list correctly" do
    string_length =
      SteamBot.Handler.BotUsers.interpret_response([get_user()])
      |> String.length()

    assert string_length > 0
  end

  def get_user do
    %SteamBot.Schema.User{
      steam_id: "123",
      discord_id: "123",
      steam_name: "name",
      discord_name: "name"
    }
  end
end
