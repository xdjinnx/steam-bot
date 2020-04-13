defmodule Category do
  use Ecto.Schema
  import Ecto.Changeset

  schema "categories" do
    belongs_to(:game, Game)
    field(:description, :string)
    field(:category_id, :integer)
    timestamps()
  end

  def changeset(entity, params \\ %{}) do
    change(entity)
    |> change(params)
  end
end