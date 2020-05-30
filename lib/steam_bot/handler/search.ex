defmodule SteamBot.Handler.Search do
  def ask(search_string) do
    SteamBot.GreenManGaming.API.search(search_string)
    |> create_link_object()
  end

  defp create_link_object(green_game) do
    "https://www.greenmangaming.com" <> green_game["Url"]
  end

  def interpret_response(link) do
    link
  end
end
