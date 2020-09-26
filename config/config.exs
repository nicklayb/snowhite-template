import Config

config :snowhite_template, SnowhiteTemplateWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "70a53nWm5Iw8fDh6d+6DjsTxVkMxzkpvSckUWaQEgY5rmpsm+Ae6cbGXL3HxGaKU",
  render_errors: [view: SnowhiteTemplateWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: SnowhiteTemplate.PubSub,
  live_view: [signing_salt: "FXXTYjTg"]

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phoenix, :json_library, Jason

import_config "#{Mix.env()}.exs"
