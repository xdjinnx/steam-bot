defmodule SteamBot.Repo.Migrations.CreateUniqueIndexUsers do
  use Ecto.Migration

  def change do
    create unique_index(:users, [:discord_id])
  end
end
