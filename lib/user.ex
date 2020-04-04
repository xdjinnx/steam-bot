defmodule User do
  use Ecto.Schema

  schema "users" do
    field :discord_name, :string
    field :steam_name, :string
    field :discord_id, :string
    field :steam_id, :string
    timestamps()
  end
end