defmodule Func do
  alias Alchemy.Client

  def add do
    'add <steam-id>'
  end

  def add(member, arg1) do
    case Integer.parse(arg1) do
      {steam_id, _} -> case Query.insert_user(%User{steam_id: steam_id}) do
        {:ok, _} -> 'Thank you %{discord_name}, I have added: %{steam_name}!'
        {:error, _} -> 'Something went wrong'
      end
      :error -> 'not a valid steam id'
    end
  end

  def add(member, arg1, arg2) do
    'not implemented'
  end

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
