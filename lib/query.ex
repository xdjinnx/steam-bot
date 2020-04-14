defmodule Query do
  import Ecto.Query
  import Ecto.Changeset
  alias Ecto.Multi

  def get_all_users do
    query =
      from(u in User,
        select: u
      )

    Repo.all(query)
  end

  def get_users(ids) do
    query =
      from(u in User,
        where: u.discord_id in ^ids,
        select: u
      )

    Repo.all(query)
  end

  def get_user(id) do
    query =
      from(u in User,
        where: u.discord_id == ^id,
        select: u
      )

    Repo.all(query)
    |> List.first()
  end

  def insert_user(user) do
    Repo.insert(user)
  end

  def get_games(ids) do
    query =
      from(g in Game,
        where: g.app_id in ^ids,
        select: g
      )

    Repo.all(query)
  end

  def insert_games_with_tags(games_with_tags) do
    Enum.map(games_with_tags, fn game_with_tags -> insert_game_with_tags(game_with_tags) end)
  end

  def insert_game_with_tags({game, categories, genres}) do
    multi = Multi.new()
    |> Multi.insert(:insert_game, game)

    categories_multi = Enum.reduce(categories, multi, fn category, acc_multi ->
      Multi.insert(acc_multi, {:category, category.category_id}, fn %{insert_game: game} ->
        category
        |> Ecto.Changeset.cast(%{:game_id => game.id}, [:game_id])
        |> Ecto.Changeset.assoc_constraint(:game)
      end)
    end)

    genres_multi = Enum.reduce(genres, categories_multi, fn genre, acc_multi ->
      Multi.insert(acc_multi, {:genre, genre.genre_id}, fn %{insert_game: game} ->
        genre
        |> Ecto.Changeset.cast(%{:game_id => game.id}, [:game_id])
        |> Ecto.Changeset.assoc_constraint(:game)
      end)
    end)

    Repo.transaction(genres_multi)
  end
end
