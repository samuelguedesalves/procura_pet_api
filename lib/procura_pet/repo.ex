defmodule ProcuraPet.Repo do
  use Ecto.Repo,
    otp_app: :procura_pet,
    adapter: Ecto.Adapters.Postgres
end
