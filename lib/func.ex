defmodule Func do
  alias Alchemy.Client

  def add do
    'add <steam-id>'
  end

  def add(member, arg1) do
    Steam.get_user(arg1)
    |> insert_user
    |> add_response
  end

  def add(member, arg1, arg2) do
    'not implemented'
  end

  defp insert_user(steam_user), do: Query.insert_user(%User{
    steam_name: steam_user["personaname"],
    steam_id: steam_user["steamid"]
  })

  defp add_response({:ok, user}), do: "Thank you %{discord_name}, I have added: #{user.steam_name}!"

  defp add_response({:error, _}), do: 'Something went wrong'

  def compare(member) do
    'not implemented'
  end

  def discordUsers do
    'not implemented'
  end

  def botUsers do
    Query.get_all_users()
  end
end
