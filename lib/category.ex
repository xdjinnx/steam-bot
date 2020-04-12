defmodule Category do
  use Ecto.Schema

  schema "categories" do
    belongs_to(:game, Game)
    field(:description, :string)
    field(:category_id, :integer)
    timestamps()
  end
end