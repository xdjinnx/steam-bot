defmodule SteamBot.Steam do
  use Tesla

  plug(Tesla.Middleware.BaseUrl, "https://api.github.com")
  plug(Tesla.Middleware.JSON)

  def steam_key(), do: Application.get_env(:steam_bot, :steam_key)

  def get_user(steam_id) do
    SteamEx.ISteamUser.get_player_summaries(steam_key, %{
      "steamids" => steam_id
    })
    |> decode_body
    |> get_first_user
  end

  defp get_first_user({:error, reason}), do: {:error, reason}

  defp get_first_user(body) do
    List.first(body["response"]["players"])
  end

  def get_owned_games(steam_id) do
    SteamEx.IPlayerService.get_owned_games(steam_key, %{
      "steamid" => steam_id,
      "include_appinfo" => true
    })
    |> decode_body
    |> get_games
  end

  defp get_games({:error, reason}), do: {:error, reason}

  defp get_games(body) do
    body["response"]["games"]
  end

  def get_app_info(appid) do
    get("https://store.steampowered.com/api/appdetails?appids=" <> Integer.to_string(appid))
    |> get_app_info(appid)
  end

  # defp get_app_info({:ok, response}, appid), do: response.body[Integer.to_string(appid)]["data"]
  defp get_app_info({:ok, response}, appid) do
    cond do
      response.body[Integer.to_string(appid)]["success"] ->
        response.body[Integer.to_string(appid)]["data"]

      true ->
        %{
          "categories" => [
            %{"description" => "Multi-player", "id" => 1}
          ]
        }
    end
  end

  def is_multiplayer?(app_info) do
    # id number 1 is multiplayer
    Enum.any?(app_info["categories"], fn category -> category["id"] == 1 end)
  end

  defp decode_body(response) do
    Jason.decode!(response.body)
  rescue
    Jason.DecodeError ->
      {:error, 'could not parse body'}
  end
end
