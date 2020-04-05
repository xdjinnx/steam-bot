defmodule Steam do
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

  defp decode_body(response) do
    Poison.decode!(response.body)
  rescue
    Poison.ParseError ->
      {:error, 'could not parse body'}
  end
end
