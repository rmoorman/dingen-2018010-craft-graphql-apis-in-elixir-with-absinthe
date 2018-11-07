defmodule PlateSlateWeb.Router do
  use PlateSlateWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug PlateSlateWeb.Plug.Context
  end

  scope "/", PlateSlateWeb do
    pipe_through :browser

    get "/", PageController, :index
  end

  scope "/api", PlateSlateWeb.GraphQL do
    pipe_through :api

    forward "/graphql", Plug
    forward "/graphiql", GraphiQL.Simple
    forward "/graphiql-advanced", GraphiQL.Advanced
    forward "/graphiql-playground", GraphiQL.Playground
  end

  scope "/admin", PlateSlateWeb do
    pipe_through :browser

    resources "/items", ItemController
  end
end
