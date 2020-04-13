defmodule Query do
  import Ecto.Query
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
    |> IO.inspect

    categories_with_game_id = Enum.map(categories, fn category ->
      Category.changeset(category, %{:game_id => multi.insert_game.id})
    end)

    genres_with_game_id = Enum.map(genres, fn genre ->
      Genre.changeset(genre, %{:game_id => multi.insert_game.id})
    end)

    Multi.insert_all(multi, :insert_all_categories, Category, categories_with_game_id)
    |> Multi.insert_all(:insert_all_genres, Genre, genres_with_game_id)
    |> Repo.transaction()
  end
end
