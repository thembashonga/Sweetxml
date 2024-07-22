defmodule Sweetxml.Repo do
  use Ecto.Repo,
    otp_app: :sweetxml,
    adapter: Ecto.Adapters.Postgres
end
