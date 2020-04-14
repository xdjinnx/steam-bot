defmodule Genre do
  use Ecto.Schema

  schema "genres" do
    belongs_to(:game, Game)
    field(:description, :string)
    field(:genre_id, :string)
    timestamps()
  end
end