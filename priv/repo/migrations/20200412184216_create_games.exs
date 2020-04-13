defmodule Repo.Migrations.CreateGames do
  use Ecto.Migration

  def change do
    create table(:games) do
      add(:app_id, :integer)
      add(:name, :string)
      add(:categories, :string)
      add(:genres, :string)
      timestamps()
    end
  end
end
