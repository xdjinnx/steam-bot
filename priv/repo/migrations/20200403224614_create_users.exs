defmodule Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add(:discord_name, :string)
      add(:steam_name, :string)
      add(:discord_id, :string)
      add(:steam_id, :string)
      timestamps()
    end
  end
end
