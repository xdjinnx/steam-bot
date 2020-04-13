defmodule Genre do
  use Ecto.Schema
  import Ecto.Changeset

  schema "genres" do
    belongs_to(:game, Game)
    field(:description, :string)
    field(:genre_id, :integer)
    timestamps()
  end

  def changeset(entity, params \\ %{}) do
    change(entity)
    |> change(params)
  end
end