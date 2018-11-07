defmodule PlateSlateWeb.SessionController do
  use PlateSlateWeb, :controller

  use Absinthe.Phoenix.Controller, schema: PlateSlateWeb.GraphQL.Schema

  def new(conn, _) do
    render(conn, "new.html")
  end
end
