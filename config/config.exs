# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :procura_pet,
  ecto_repos: [ProcuraPet.Repo]

# Configures the endpoint
config :procura_pet, ProcuraPetWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "23yJKRtoXG7nGXacZWdm8p3xgN/OZjdGuBU1w9kvFFEtPaKxW9+E9tDUQkCwSx3R",
  render_errors: [view: ProcuraPetWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: ProcuraPet.PubSub,
  live_view: [signing_salt: "VVGt1E7h"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Secret key. You can use `mix guardian.gen.secret` to get one
config :procura_pet, ProcuraPet.Guardian,
  issuer: "procura_pet",
  secret_key: "bO+90Wxn68S2o/Lz3j/7tUsfUoVLu+dJMNp7hPfPlAXB3PaPdoxokYD3AUVuvQIO"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
