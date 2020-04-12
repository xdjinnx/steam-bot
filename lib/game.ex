defmodule Game do
  use Ecto.Schema

  schema "games" do
    field(:app_id, :string)
    field(:name, :string)
    field(:categories, :string)
    field(:genres, :string)
    timestamps()
  end
end