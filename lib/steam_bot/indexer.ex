defmodule SteamBot.Indexer do
  use Task

  def start_link(arg) do
    Task.start_link(__MODULE__, :run, [arg])
  end

  def run(arg) do
    BlockingQueue.pop(BlockingQueue, :infinity)
    |> (fn app_ids -> [SteamBot.Steam.get_app_info(List.first(app_ids))] end).()
    |> insert_games
  end

  defp insert_games(games) do
    Enum.map(games, fn game ->
      {
        %SteamBot.Schema.Game{
          app_id: game["steam_appid"],
          name: game["name"]
        },
        Enum.map(game["categories"], fn category ->
          %SteamBot.Schema.Category{
            description: category["description"],
            category_id: category["id"]
          }
        end),
        Enum.map(game["genres"], fn genre ->
          %SteamBot.Schema.Genre{
            description: genre["description"],
            genre_id: genre["id"]
          }
        end)
      }
    end)
    |> SteamBot.Query.insert_games_with_tags()
  end
end
