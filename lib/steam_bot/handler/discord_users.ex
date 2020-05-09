defmodule SteamBot.Handler.DiscordUsers do
  def ask({:ok, guild_id}) do
    SteamBot.Discord.get_members(guild_id)
  end

  def interpret_response(guild_members) do
    guild_members
    |> List.foldl("", fn guild_member, acc ->
      acc <> "#{guild_member.user.username}:#{guild_member.user.id}, "
    end)
  end
end
