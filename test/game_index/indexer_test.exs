defmodule GameIndex.IndexerTest do
  use SteamBot.RepoCase
  use ExUnit.Case

  import Mox

  setup :verify_on_exit!

  test "can index a game into the database" do
    SteamBot.SteamMock
    |> expect(:get_app_info, fn _ ->
      {:ok,
       %{
         "name" => "Random name",
         "categories" => [
           %{
             "description" => "Multiplayer",
             "id" => 1
           }
         ],
         "genres" => [
           %{
             "description" => "RPG",
             "id" => "123"
           }
         ]
       }}
    end)

    SteamBot.GameIndex.Indexer.index_game([], 123)

    games = SteamBot.Query.get_games_with_tags([123])

    assert Enum.count(games) == 1
    assert List.first(games).name == "Random name"
    assert Enum.count(List.first(games).categories) == 1
    assert List.first(List.first(games).categories).category_id == 1
    assert List.first(List.first(games).categories).description == "Multiplayer"
    assert Enum.count(List.first(games).genres) == 1
    assert List.first(List.first(games).genres).genre_id == "123"
    assert List.first(List.first(games).genres).description == "RPG"
  end
end
