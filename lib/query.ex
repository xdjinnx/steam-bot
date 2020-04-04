defmodule Query do
  import Ecto.Query

  def get_all_users do
    query =
      from(u in User,
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
  end

  def insert_user(user) do
    Repo.insert(user)
  end
end
