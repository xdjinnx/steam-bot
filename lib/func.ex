defmodule Func do
  alias Alchemy.Client

  def add do
    'add <steam-id>'
  end

  def add({:ok, guild_member}, steam_id) do
    Steam.get_user(steam_id)
    |> insert_user(guild_member.user)
    |> add_response
  end

  def add({:ok, guild_id}, steam_id, discord_id) do
    guild_member = Discord.get_member(guild_id, discord_id)

    add({:ok, guild_member}, steam_id)
  end

  defp insert_user(steam_user, discord_user),
    do:
      Query.insert_user(%User{
        discord_id: discord_user.id,
        discord_name: discord_user.username,
        steam_name: steam_user["personaname"],
        steam_id: steam_user["steamid"]
      })

  defp add_response({:ok, user}),
    do: "#{user.discord_name} has been connected to steam user #{user.steam_name}!"

  defp add_response({:error, _}), do: 'Something went wrong when writing to database'

  def compare({:ok, guild_member}, {:ok, guild_id}) do
    channel_id = Discord.get_current_voice_channel(guild_id, guild_member.user.id)

    Discord.get_members_in_voice_channel(guild_id, channel_id)
    |> get_registered_users
    |> Enum.map(fn user -> {user, Steam.get_owned_games(user.steam_id)} end)
    |> compare_games

    # |> Create response
  end

  defp compare_games(users_games) do
    {_, games} = List.first(users_games)

    List.foldl(users_games, games, fn {_, games}, acc ->
      Enum.filter(acc, fn {_, game} -> is_game_in_list?(games, game) end)
    end)
  end

  defp is_game_in_list?(games, game) do
    Enum.any?(games, fn games_game -> games_game["appid"] == game["appid"] end)
  end

  defp get_registered_users(guild_members) do
    Enum.map(guild_members, fn guild_member -> Query.get_user(guild_member.user.id) end)
    |> Enum.filter(fn users -> users != [] end)
    |> Enum.map(fn users -> List.first(users) end)
  end

  def discord_users({:ok, guild_id}) do
    Discord.get_members(guild_id)
    |> List.foldl("", fn guild_member, acc ->
      acc <> "#{guild_member.user.username}:#{guild_member.user.id}, "
    end)
  end

  def bot_users do
    Query.get_all_users()
    |> List.foldl("", fn user, acc ->
      acc <> "#{user.discord_name}: #{user.steam_name}(#{user.steam_id}), "
    end)
  end
end
