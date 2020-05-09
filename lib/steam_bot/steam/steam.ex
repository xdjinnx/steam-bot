defmodule SteamBot.Steam do
  @moduledoc false
  @callback get_user(String.t()) :: user

  @type user :: %{}
end
