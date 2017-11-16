defmodule ChaacServerWeb.Router do
  use ChaacServerWeb, :router

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

  scope "/", ChaacServerWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  scope "/api", ChaacServerWeb do
    pipe_through :api

    resources "/users", UserController, except: [:new, :edit] do
      resources "/photos", PhotoController, except: [:new, :edit]
    end
  end
end
