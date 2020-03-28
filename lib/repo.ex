defmodule Repo do
  use Ecto.Repo, otp_app: :steam_bot, adapter: Sqlite.Ecto2
end
