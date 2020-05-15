defmodule SteamBot.Handler.Index do
  def steam_api, do: Application.get_env(:steam_bot, :steam_api, SteamBot.Steam.API)

  def ask({:ok, guild_member}) do
    ask(guild_member.user.id)
  end

  def ask(discord_id) do
    user = SteamBot.Query.get_user(discord_id)

    steam_api().get_owned_games(user.steam_id)
    |> Enum.map(fn game -> game["appid"] end)
    |> filter_need_indexing
    |> Enum.reduce([], fn app_id, _ -> SteamBot.GameIndex.IndexQueue.push(app_id) end)

    user
  end

  def interpret_response(user) do
    "I will index " <> user.discord_name <> "'s games!"
  end

  defp filter_need_indexing([]), do: []

  defp filter_need_indexing(app_ids) do
    indexed_games = SteamBot.Query.get_games(app_ids)

    Enum.filter(app_ids, fn app_id ->
      !Enum.any?(indexed_games, fn game -> game.app_id == app_id end)
    end)
  end
end
