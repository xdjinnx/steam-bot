defmodule Repo.Migrations.AlterGames do
  use Ecto.Migration

  def change do
    alter table("games") do
      remove(:categories)
      remove(:genres)
    end
  end
end
