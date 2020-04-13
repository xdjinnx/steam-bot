defmodule User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field(:discord_name, :string)
    field(:steam_name, :string)
    field(:discord_id, :string)
    field(:steam_id, :string)
    timestamps()
  end

  def changeset(entity, params \\ %{}) do
    change(entity)
    |> change(params)
  end
end
