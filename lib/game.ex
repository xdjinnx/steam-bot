defmodule Game do
  use Ecto.Schema

  schema "games" do
    field(:app_id, :integer)
    field(:name, :string)
    has_many(:categories, Category)
    has_many(:genres, Genre)
    timestamps()
  end
end