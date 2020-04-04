defmodule Discord do
  alias Alchemy.Client
  alias Alchemy.Cache

  def get_members(guild_id) do
    {:ok, guild_members} = Client.get_member_list(guild_id, limit: 100)
    guild_members
  end

  def get_member(guild_id, user_id) do
    {:ok, guild_member} = Client.get_member(guild_id, user_id)
    guild_member
  end

  def get_current_voice_channel(guild_id, user_id) do
    {:ok, voice_state} = Cache.voice_state(guild_id, user_id)
    voice_state.channel_id
  end

  def get_members_in_voice_channel(guild_id, channel_id) do
    get_members(guild_id)
    |> Enum.filter(fn guild_member ->
      is_user_connected_to_channel?(guild_id, channel_id, guild_member.user.id)
    end)
  end

  defp is_user_connected_to_channel?(guild_id, channel_id, user_id) do
    case Cache.voice_state(guild_id, user_id) do
      {:ok, voice_state} -> voice_state.channel_id == channel_id
      {:error, _} -> false
    end
  end
end
