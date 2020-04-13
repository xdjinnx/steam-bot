defmodule Game do
  use Ecto.Schema
  import Ecto.Changeset

  schema "games" do
    field(:app_id, :integer)
    field(:name, :string)
    has_many(:categories, Category)
    has_many(:genres, Genre)
    timestamps()
  end

  def changeset(entity, params \\ %{}) do
    change(entity)
    |> change(params)
  end
end