defmodule SnowhiteTemplate.Profiles do
  use Snowhite, timezone: "America/Toronto"
  alias __MODULE__

  profile(:default, Profiles.Default)
end
