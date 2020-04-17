defmodule SteamBot.Schema.Genre do
  use Ecto.Schema

  schema "genres" do
    belongs_to(:game, SteamBot.Schema.Game)
    field(:description, :string)
    field(:genre_id, :string)
    timestamps()
  end
end
