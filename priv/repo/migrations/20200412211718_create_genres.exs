defmodule Repo.Migrations.CreateGenres do
  use Ecto.Migration

  def change do
    create table(:genres) do
      add(:game_id, references(:games))
      add(:description, :string)
      add(:genre_id, :string)
      timestamps()
    end
  end
end
