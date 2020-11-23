defmodule SnowhiteTemplate.Profiles.Default do
  use Snowhite.Builder.Profile

  configure(
    city_id: "6167865",
    timezone: "America/Toronto",
    locale: "en",
    units: :metric
  )

  register_module(:top_left, Snowhite.Modules.Clock)

  register_module(:top_left, Snowhite.Modules.Calendar)

  register_module(:top_right, Snowhite.Modules.Weather.Current, refresh: ~d(4h))

  register_module(:top_right, Snowhite.Modules.Weather.Forecast, refresh: ~d(4h))

  register_module(:top_left, Snowhite.Modules.Rss,
    feeds: [
      {"Hacker News", "https://hnrss.org/newest"}
    ],
    persist_app: :snowhite,
    qr_codes: false
  )

  register_module(:top_right, Snowhite.Modules.Suntime,
    latitude: 43.653225,
    longitude: -79.383186
  )
end
