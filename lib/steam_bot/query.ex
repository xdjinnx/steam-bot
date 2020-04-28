defmodule SteamBot.Query do
  import Ecto.Query
  alias Ecto.Multi

  def get_all_users do
    query =
      from(u in SteamBot.Schema.User,
        select: u
      )

    SteamBot.Repo.all(query)
  end

  def get_users(ids) do
    query =
      from(u in SteamBot.Schema.User,
        where: u.discord_id in ^ids,
        select: u
      )

    SteamBot.Repo.all(query)
  end

  def get_user(id) do
    query =
      from(u in SteamBot.Schema.User,
        where: u.discord_id == ^id,
        select: u
      )

    SteamBot.Repo.all(query)
    |> List.first()
  end

  def insert_or_update_user(user) do
    Ecto.Multi.new()
    |> Ecto.Multi.run(:get, fn repo, _changes ->
      case repo.get_by(SteamBot.Schema.User, discord_id: user.discord_id) do
        u -> {:ok,
               u
               |> Ecto.Changeset.change(%{
                 discord_name: user.discord_name,
                 steam_name: user.steam_name,
                 steam_id: user.steam_id
               })
             }
        nil -> {:ok, user}
      end
    end)
    |> Ecto.Multi.insert_or_update(:update, fn %{get: u} ->
      Ecto.Changeset.change(u)
      |> Ecto.Changeset.unique_constraint(:discord_id)
    end)
    |> SteamBot.Repo.transaction()
    |> get_inserted_user()
  end

  defp get_inserted_user({:ok, %{update: u}}), do: {:ok, u}
  defp get_inserted_user(error), do: error

  def get_games(ids) do
    query =
      from(g in SteamBot.Schema.Game,
        where: g.app_id in ^ids,
        select: g
      )

    SteamBot.Repo.all(query)
  end

  def get_games_with_tags(ids) do
    query =
      from(g in SteamBot.Schema.Game,
        where: g.app_id in ^ids,
        select: g,
        preload: [:genres, :categories]
      )

    SteamBot.Repo.all(query)
  end

  def get_game(id) do
    query =
      from(g in SteamBot.Schema.Game,
        where: g.app_id == ^id,
        select: g
      )

    SteamBot.Repo.all(query)
  end

  def insert_game_with_tags({game, categories, genres}) do
    multi =
      Multi.new()
      |> Multi.insert(:insert_game, game)

    categories_multi =
      Enum.reduce(categories, multi, fn category, acc_multi ->
        Multi.insert(acc_multi, {:category, category.category_id}, fn %{insert_game: game} ->
          category
          |> Ecto.Changeset.cast(%{:game_id => game.id}, [:game_id])
          |> Ecto.Changeset.assoc_constraint(:game)
        end)
      end)

    genres_multi =
      Enum.reduce(genres, categories_multi, fn genre, acc_multi ->
        Multi.insert(acc_multi, {:genre, genre.genre_id}, fn %{insert_game: game} ->
          genre
          |> Ecto.Changeset.cast(%{:game_id => game.id}, [:game_id])
          |> Ecto.Changeset.assoc_constraint(:game)
        end)
      end)

    SteamBot.Repo.transaction(genres_multi)
  end
end
