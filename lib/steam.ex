defmodule Steam do
  def get_user(steam_id) do
    key = "8C1444D72335D5A78A543DBB1CDE6A91"

    SteamEx.ISteamUser.get_player_summaries(key, %{
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
    key = "8C1444D72335D5A78A543DBB1CDE6A91"

    SteamEx.IPlayerService.get_owned_games(key, %{
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

  defp decode_body(response) do
    Poison.decode!(response.body)
  rescue
    Poison.ParseError ->
      {:error, 'could not parse body'}
  end
end
