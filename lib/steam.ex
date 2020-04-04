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

  defp get_body(request_response) do
    request_response.body
  end

  defp get_first_user(body) do
    List.first(body["response"]["players"])
  end
end
