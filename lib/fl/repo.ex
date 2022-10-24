defmodule Fl.Repo do
  use Ecto.Repo,
    otp_app: :fl,
    adapter: Ecto.Adapters.Postgres
end
