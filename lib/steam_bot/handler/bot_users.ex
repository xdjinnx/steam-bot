defmodule SteamBot.Handler.BotUsers do
  def bot_users do
    SteamBot.Query.get_all_users()
    |> List.foldl("", fn user, acc ->
      acc <> "#{user.discord_name}: #{user.steam_name}(#{user.steam_id}), "
    end)
  end
end