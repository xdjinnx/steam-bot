defmodule SteamBot.GameIndex.Indexer do
  use Task, restart: :permanent

  def steam_api, do: Application.get_env(:steam_bot, :steam_api, SteamBot.Steam.API)

  def start_link(no_arg) do
    Task.start_link(__MODULE__, :run, [no_arg])
  end

  def run(no_arg) do
    app_id = SteamBot.GameIndex.IndexQueue.pop()

    SteamBot.Query.get_game(app_id)
    |> wait()
    |> index_game(app_id)

    run(no_arg)
  end

  defp wait(game) do
    Process.sleep(1000)
    game
  end

  def index_game([], app_id) do
    steam_api().get_app_info(app_id)
    |> validate_game_data()
    |> insert_game(app_id)
  end

  def index_game(_, _), do: :ok

  defp validate_game_data({:error, r}), do: {:error, r}

  defp validate_game_data({:ok, game}) do
    cond do
      game["name"] != "" && !is_nil(game["categories"]) && !is_nil(game["genres"]) -> game
      true -> {:error, :invalid}
    end
  end

  defp insert_game({:error, :invalid}, _) do
    IO.puts("Data is broken")
  end

  defp insert_game({:error, _}, _) do
    "We need to handle error somehow"
  end

  defp insert_game(game, app_id) do
    SteamBot.Query.insert_game_with_tags({
      %SteamBot.Schema.Game{
        app_id: app_id,
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
