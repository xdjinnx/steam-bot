defmodule Repo.Migrations.CreateCategories do
  use Ecto.Migration

  def change do
    create table(:categories) do
      add(:game_id, :integer)
      add(:description, :string)
      add(:categories_id, :integer)
      timestamps()
    end
  end
end
