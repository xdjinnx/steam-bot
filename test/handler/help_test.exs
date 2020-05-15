defmodule Handler.HelpTest do
  use SteamBot.RepoCase
  use ExUnit.Case

  test "return a help string" do
    help_string_length =
      SteamBot.Handler.Help.get_response()
      |> String.length()

    assert help_string_length > 0
  end
end
