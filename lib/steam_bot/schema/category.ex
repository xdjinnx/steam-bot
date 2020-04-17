defmodule SteamBot.Schema.Category do
  use Ecto.Schema

  schema "categories" do
    belongs_to(:game, SteamBot.Schema.Game)
    field(:description, :string)
    field(:category_id, :integer)
    timestamps()
  end
end
