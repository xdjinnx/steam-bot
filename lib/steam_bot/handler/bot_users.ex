defmodule SteamBot.Handler.BotUsers do
  def ask do
    SteamBot.Query.get_all_users()
  end

  def interpret_response(users) do
    users
    |> List.foldl("", fn user, acc ->
      acc <> "#{user.discord_name}: #{user.steam_name}(#{user.steam_id}), "
    end)
  end
end