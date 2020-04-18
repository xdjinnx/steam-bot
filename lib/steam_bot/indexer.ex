defmodule SteamBot.Indexer do
  use Task, restart: :permanent

  def start_link(no_arg) do
    Task.start_link(__MODULE__, :run, [no_arg])
  end

  def run(no_arg) do
    app_id = SteamBot.IndexQueue.pop()

    case SteamBot.Query.get_game(app_id) do
      [] -> index_game(app_id)
      _ -> run(no_arg)
    end
  end

  defp index_game(app_id) do
    Process.sleep(1000)

    SteamBot.Steam.get_app_info(app_id)
    |> insert_game
  end

  defp insert_game(game) do
    SteamBot.Query.insert_game_with_tags({
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
    })
  end
end
