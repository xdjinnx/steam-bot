defmodule AddTest do
  use SteamBot.RepoCase
  use ExUnit.Case

  test "gets help if no arguments are applied" do
    string_length = SteamBot.Handler.Add.ask()
                         |> String.length()

    assert string_length > 0
  end

  test "can add a user" do
  end
end
