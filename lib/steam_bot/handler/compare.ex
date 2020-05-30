defmodule SteamBot.Handler.Compare do
  def steam_api, do: Application.get_env(:steam_bot, :steam_api, SteamBot.Steam.API)
  def discord_api, do: Application.get_env(:steam_bot, :discord_api, SteamBot.Discord.API)

  def ask({:ok, guild_member}, {:ok, guild_id}) do
    channel_id = discord_api().get_current_voice_channel(guild_id, guild_member.user.id)

    {users, compare_map} = get_users_games(guild_id, channel_id)

    {
      users,
      Map.get(compare_map, Enum.count(users), []),
      get_recommended_games(users, compare_map)
    }
  end

  defp get_users_games(guild_id, channel_id) do
    discord_api().get_members_in_voice_channel(guild_id, channel_id)
    |> Enum.map(fn guild_member -> guild_member.user.id end)
    |> SteamBot.Query.get_users()
    |> Enum.map(fn user -> {user, steam_api().get_owned_games(user.steam_id)} end)
    |> Enum.filter(fn {_, games} -> !is_nil(games) end)
    |> compare_games
    |> filter_multiplayer
  end

  defp filter_multiplayer({users, compare_map}) do
    games_with_tags =
      Enum.reduce(1..Enum.count(users), [], fn i, acc ->
        Map.get(compare_map, i, [])
        |> Enum.map(fn game -> game["appid"] end)
        |> SteamBot.Query.get_games_with_tags()
        |> Enum.concat(acc)
      end)

    {users,
     Enum.reduce(1..Enum.count(users), %{}, fn i, acc ->
       multiplayer_games =
         Map.get(compare_map, i, [])
         |> Enum.filter(fn game ->
           Enum.find(games_with_tags, fn game_with_tags ->
             game_with_tags.app_id == game["appid"]
           end)
           |> is_multiplayer
         end)

       Map.put(acc, i, multiplayer_games)
     end)}
  end

  defp is_multiplayer(nil), do: false

  defp is_multiplayer(game),
    do: Enum.any?(game.categories, fn category -> category.category_id == 1 end)

  defp compare_games(users_games) do
    {
      List.foldl(users_games, [], fn {user, _}, acc -> [user | acc] end),
      get_list_of_all_games(users_games)
      |> get_compare_map(users_games)
    }
  end

  defp get_list_of_all_games(users_games) do
    Enum.reduce(users_games, [], fn {_, games}, acc -> Enum.concat(acc, games) end)
    |> Enum.uniq_by(fn %{"appid" => id} -> id end)
  end

  defp get_compare_map(games, users_games) do
    Enum.reduce(games, %{}, fn game, acc ->
      owners_count = count_owners(game, users_games)
      Map.put(acc, owners_count, [game | Map.get(acc, owners_count, [])])
    end)
  end

  defp count_owners(game, users_games) do
    Enum.reduce(users_games, 0, fn {_, games}, acc ->
      case is_game_in_list?(games, game) do
        true -> acc + 1
        false -> acc
      end
    end)
  end

  defp is_game_in_list?(games, game) do
    Enum.any?(games, fn games_game -> games_game["appid"] == game["appid"] end)
  end

  defp get_recommended_games(users, compare_map) do
    game =
      Map.get(compare_map, Enum.count(users) - 1, [])
      |> Enum.shuffle()
      |> List.first()

    case game do
      nil -> []
      _ -> [game]
    end
  end

  def interpret_response({users, all_owned_games, recommended_games}) do
    owners = List.foldl(users, "", fn user, acc -> acc <> "<@#{user.discord_id}>, " end)
    in_common = List.foldl(all_owned_games, "", fn game, acc -> acc <> game["name"] <> ", " end)
    count = Enum.count(all_owned_games) |> Integer.to_string()
    first_recommended_game = List.first(recommended_games)

    recommended_game =
      case first_recommended_game do
        nil -> ""
        _ -> "**One person is missing** " <> first_recommended_game["name"] <> ", **but** "
      end

    recommended_game <> owners <> " **have** " <> count <> " **games in common:** " <> in_common
  end
end
