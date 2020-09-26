defmodule SnowhiteTemplateWeb.Router do
  use Phoenix.Router

  import Plug.Conn
  import Phoenix.Controller
  import Snowhite, only: [snowhite_router: 1]

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipe_through :browser

  snowhite_router(SnowhiteTemplate.Profiles)
end
