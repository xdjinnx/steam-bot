defmodule SteamBot.Handler.DiscordUsers do
  def discord_users({:ok, guild_id}) do
    SteamBot.Discord.get_members(guild_id)
    |> List.foldl("", fn guild_member, acc ->
      acc <> "#{guild_member.user.username}:#{guild_member.user.id}, "
    end)
  end
end