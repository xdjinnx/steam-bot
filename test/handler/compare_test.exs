defmodule CompareTest do
  use SteamBot.RepoCase
  use ExUnit.Case

  import Mox

  setup :verify_on_exit!

  test "can compare users games" do
    SteamBot.DiscordMock
    |> expect(:get_current_voice_channel, fn x, y ->
      %{}
    end)
    |> expect(:get_members_in_voice_channel, fn x, y ->
      []
    end)

    SteamBot.Handler.Compare.ask({:ok, %{}}, {:ok, "random_guild_id"})
  end
end
