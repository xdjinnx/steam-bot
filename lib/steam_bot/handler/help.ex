defmodule SteamBot.Handler.Help do
  def get_response() do
    "add <steam_id> [, <discord_id>] - Connect steam and discord user
compare - Compare steam games with everyone in your voice chat
discord-users - Display all discord users and their id
bot-users - Display all connected users
index [, <discord_id>]- Index your steam games manually"
  end
end
