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
    games = List.foldl(games_with_tags, [], fn {game, _, _}, acc -> [game | acc] end)
    categories = List.foldl(games_with_tags, [], fn {_, categories, _}, acc -> categories ++ acc end)
    genres = List.foldl(games_with_tags, [], fn {_, _, genres}, acc -> genres ++ acc end)

    IO.inspect(games)
    IO.inspect(categories)
    IO.inspect(genres)

    Multi.new()
    |> Multi.insert_all(:insert_all, Game, games)
    |> Multi.insert_all(:insert_all, Category, categories)
    |> Multi.insert_all(:insert_all, Genre, genres)
    |> Repo.transaction()
  end
end
