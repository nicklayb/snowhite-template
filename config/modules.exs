import Config

config :bitly, access_token: System.get_env("BITLY_TOKEN")

config :snowhite, :modules,
  weather: [
    api_key: System.get_env("OPEN_WEATHER_API_KEY")
  ]
