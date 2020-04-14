defmodule Repo.Migrations.CreateCategories do
  use Ecto.Migration

  def change do
    create table(:categories) do
      add(:game_id, references(:games))
      add(:description, :string)
      add(:category_id, :integer)
      timestamps()
    end
  end
end
