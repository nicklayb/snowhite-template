import Config

port = System.get_env("PORT") || 80
host = System.get_env("HOST") || "localhost"
level = System.get_env("LOG_LEVEL") || "info"

config :snowhite_template, SnowhiteTemplateWeb.Endpoint,
  http: [port: port],
  url: [host: host],
  secret_key_base: System.get_env("SECRET_KEY_BASE"),
  live_view: [signing_salt: System.get_env("LIVE_VIEW_SALT")],
  check_origin: false,
  server: true

config :bitly, access_token: System.get_env("BITLY_TOKEN")

config :logger, level: String.to_existing_atom(level)

config :snowhite, :modules,
  weather: [
    api_key: System.get_env("OPEN_WEATHER_API_KEY")
  ]
