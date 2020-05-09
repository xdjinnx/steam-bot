defmodule SteamBot.Discord do
  @moduledoc false
  @callback get_current_voice_channel(String.t(), String.t()) :: voice_channel
  @callback get_members_in_voice_channel(String.t(), String.t()) :: list(user)

  @type voice_channel :: %{}
  @type user :: %{}
end
