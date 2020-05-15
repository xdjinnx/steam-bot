defmodule SteamBot.Steam do
  @moduledoc false
  @callback get_user(String.t()) :: user
  @callback get_owned_games(String.t()) :: [game]
  @callback get_app_info(String.t()) :: app_info

  @type user :: %{}
  @type game :: %{}
  @type app_info :: tuple
end
