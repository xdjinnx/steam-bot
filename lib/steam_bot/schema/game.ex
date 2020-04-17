defmodule SteamBot.Schema.Game do
  use Ecto.Schema

  schema "games" do
    field(:app_id, :integer)
    field(:name, :string)
    has_many(:categories, SteamBot.Schema.Category)
    has_many(:genres, SteamBot.Schema.Genre)
    timestamps()
  end
end