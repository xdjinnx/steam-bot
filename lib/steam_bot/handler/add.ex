defmodule SteamBot.Handler.Add do
  # DI
  def steam_api, do: Application.get_env(:steam_bot, :steam_api, SteamBot.Steam.API)

  def ask(), do: SteamBot.Handler.Help.get_response()

  def ask({:ok, guild_member}, steam_id) do
    steam_api().get_user(steam_id)
    |> insert_user(guild_member.user)
    |> index_new_user
  end

  def ask({:ok, guild_id}, steam_id, discord_id) do
    guild_member = SteamBot.Discord.API.get_member(guild_id, discord_id)

    ask({:ok, guild_member}, steam_id)
  end

  defp insert_user({:error, :not_found}, _), do: {:error, :steam_user_not_found}

  defp insert_user(steam_user, discord_user),
    do:
      SteamBot.Query.insert_or_update_user(%SteamBot.Schema.User{
        discord_id: discord_user.id,
        discord_name: discord_user.username,
        steam_name: steam_user["personaname"],
        steam_id: steam_user["steamid"]
      })

  defp index_new_user({:ok, user}) do
    try do
      SteamBot.Handler.Index.ask(user.discord_id)
      {:ok, user}
    rescue
      _ -> {:error, :index_error, user}
    end
  end

  defp index_new_user(error), do: error

  def interpret_response({:ok, user}),
    do: "#{user.discord_name} has been connected to steam user #{user.steam_name}!"

  def interpret_response({:error, :index_error, user}),
    do: interpret_response({:ok, user}) <> ", problems with starting indexing"

  def interpret_response({:error, :database_error}),
    do: 'Something went wrong when writing to database'

  def interpret_response({:error, :steam_user_not_found}), do: 'Steam user not found'
end
