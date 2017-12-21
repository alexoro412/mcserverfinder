# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :dashboard,
  namespace: Dashboard,
  redis_host: "127.0.0.1",
  redis_port: 6379

# Configures the endpoint
config :dashboard, DashboardWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "9ROrhbeRE32Fe9SLw0j2DT+muLRN0WF5cCf8qw5wFTFIsSWKBLtRNy9lJ4PtNMZf",
  render_errors: [view: DashboardWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Dashboard.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
