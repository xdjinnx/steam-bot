defmodule SteamBot.Steam do
  @moduledoc false
  @callback get_user(String.t()) :: user
  @callback get_owned_games(String.t()) :: [game]

  @type user :: %{}
  @type game :: %{}
end
