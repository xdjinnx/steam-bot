defmodule DiscordUsersTest do
  use SteamBot.RepoCase
  use ExUnit.Case

  test "parse members list correctly" do
    string_length =
      SteamBot.Handler.DiscordUsers.interpret_response([get_member()])
      |> String.length()

    assert string_length > 0
  end

  def get_member do
    %{
      user: %{
        username: "name",
        id: "id"
      }
    }
  end
end
