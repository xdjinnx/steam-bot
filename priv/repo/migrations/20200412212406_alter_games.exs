defmodule Repo.Migrations.AlterGames do
  use Ecto.Migration

  def change do
    alter table("games") do
      modify(:app_id, :integer)
      remove(:categories)
      remove(:genres)
    end
  end
end
