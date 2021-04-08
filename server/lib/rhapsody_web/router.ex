defmodule RhapsodyWeb.Router do
  use RhapsodyWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers

    plug RhapsodyWeb.Plugs.FetchSession
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", RhapsodyWeb do
    pipe_through :browser

    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  scope "/api/v1", RhapsodyWeb do
    pipe_through :api

    post "/auth", PageController, :authenticate
    resources "/users", UserController, except: [:new, :edit]
    resources "/comments", CommentController, except: [:new, :edit]
    resources "/tracks", TrackController, except: [:new, :edit]
    resources "/playlists", PlaylistController, except: [:new, :edit]
    resources "/sessions", SessionController,
      only: [:create, :delete], singleton: true
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: RhapsodyWeb.Telemetry
    end
  end
end
