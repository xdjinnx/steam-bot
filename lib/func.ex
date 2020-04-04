defmodule Func do
  alias Alchemy.Client

  def add do
    'add <steam-id>'
  end

  def add(member, steam_id) do
    {:ok, guild_member} = member

    Steam.get_user(steam_id)
    |> insert_user(guild_member.user)
    |> add_response
  end

  def add(member, steam_id, discord_id) do
    'not implemented'
  end

  defp insert_user(steam_user, discord_user), do: Query.insert_user(%User{
    discord_id: discord_user.id,
    discord_name: discord_user.username,
    steam_name: steam_user["personaname"],
    steam_id: steam_user["steamid"]
  })

  defp add_response({:ok, user}), do: "#{user.discord_name} has been connected to steam user #{user.steam_name}!"

  defp add_response({:error, _}), do: 'Something went wrong'

  def compare(member) do
    'not implemented'
  end

  def discord_users(member) do
    Client.get_member_list()
  end

  def bot_users do
    Query.get_all_users()
    |> List.foldl("", fn user, acc -> acc <> "#{user.discord_name}: #{user.steam_name}(#{user.steam_id}), " end)
  end
end
