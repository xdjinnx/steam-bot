defmodule Handler.CompareTest do
  use SteamBot.RepoCase
  use ExUnit.Case

  import Mox

  setup :verify_on_exit!

  test "can compare users games" do
    SteamBot.Repo.insert(get_user())
    SteamBot.Repo.insert(get_second_user())
    SteamBot.Query.insert_game_with_tags({get_game(), get_categories(), get_genres()})
    SteamBot.Query.insert_game_with_tags({get_game_second(), get_categories_second(), get_genres_second()})

    SteamBot.DiscordMock
    |> expect(:get_current_voice_channel, fn _, _ ->
      %{}
    end)
    |> expect(:get_members_in_voice_channel, fn _, _ ->
      [
        %{user: %{id: "123"}},
        %{user: %{id: "1234"}}
      ]
    end)

    SteamBot.SteamMock
    |> expect(:get_owned_games, 2, fn _ ->
      [
        %{
          "appid" => 1234,
          "name" => "Test game"
        },
        %{
          "appid" => 12345,
          "name" => "Test game"
        }
      ]
    end)

    {users, games, recommended_games} =
      SteamBot.Handler.Compare.ask({:ok, %{user: %{id: "123"}}}, {:ok, "123"})

    assert Enum.count(users) == 2
    assert List.first(users).discord_name == "discord_name"
    assert Enum.count(games) == 2
    assert List.first(games)["name"] == "Test game"
    assert Enum.count(recommended_games) == 0
  end

  def get_user(),
    do: %SteamBot.Schema.User{
      steam_id: "123",
      discord_id: "123",
      steam_name: "steam_name",
      discord_name: "discord_name"
    }

  def get_second_user(),
      do: %SteamBot.Schema.User{
        steam_id: "1234",
        discord_id: "1234",
        steam_name: "steam_name",
        discord_name: "discord_name"
      }

  def get_game(),
    do: %SteamBot.Schema.Game{
      app_id: 1234,
      name: "Test game"
    }

  def get_categories(),
    do: [
      %SteamBot.Schema.Category{
        description: "Multiplayer",
        category_id: 1
      }
    ]

  def get_genres(),
    do: [
      %SteamBot.Schema.Genre{
        description: "something",
        genre_id: "3232"
      }
    ]

  def get_game_second(),
      do: %SteamBot.Schema.Game{
        app_id: 12345,
        name: "Test game"
      }

  def get_categories_second(),
      do: [
        %SteamBot.Schema.Category{
          description: "Multiplayer",
          category_id: 1
        }
      ]

  def get_genres_second(),
      do: [
        %SteamBot.Schema.Genre{
          description: "something",
          genre_id: "3232"
        }
      ]
end
