# https://api.greenmangaming.com/api/v2/quick_search_results/dark%20souls

defmodule SteamBot.GreenManGaming.API do
  use Tesla

  @behaviour SteamBot.Steam

  plug(Tesla.Middleware.BaseUrl, "https://api.greenmangaming.com")
  plug(Tesla.Middleware.JSON)

  def search(search_string) do
    get("https://api.greenmangaming.com/api/v2/quick_search_results/" <> URI.encode(search_string))
    |> get_first_search_result()
  end

  defp get_first_search_result({:ok, response}) do
    List.first(response.body["results"])
  end
end
