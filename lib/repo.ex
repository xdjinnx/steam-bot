defmodule Repo do
  use Ecto.Repo,
    otp_app: :steam_bot,
    adapter: Ecto.Adapters.Postgres
end
