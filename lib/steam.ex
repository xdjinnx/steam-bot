defmodule Steam do
  def get_user(steam_id) do
    key = "8C1444D72335D5A78A543DBB1CDE6A91"
    SteamEx.ISteamUser.get_player_summaries(key, %{
      "steamids" => steam_id
    })
    |> get_body
    |> Poison.decode!
    |> get_first_user
  end

  defp get_first_user(body) do
    List.first(body["response"]["players"])
  end

  def get_owned_games(steam_id) do
    key = "8C1444D72335D5A78A543DBB1CDE6A91"
    SteamEx.IPlayerService.get_owned_games(key, %{
      "steamids" => steam_id,
      "include_played_free_games" => true,
    })
    |> get_body
    |> Poison.decode!
  end

  defp get_body(request_response) do
    request_response.body
  end
end
