defmodule PlateSlateWeb.SessionController do
  use PlateSlateWeb, :controller

  use Absinthe.Phoenix.Controller, schema: PlateSlateWeb.GraphQL.Schema

  def new(conn, _) do
    render(conn, "new.html")
  end

  @graphql """
  mutation ($email: String!, $password: String!) @action(mode: INTERNAL) {
    login(role: EMPLOYEE, email: $email, password: $password)
  }
  """
  def create(conn, %{data: %{login: result}}) do
    case result do
      %{user: user, token: _token} ->
        conn
        |> put_session(:employee_id, user.id)
        |> put_flash(:info, "Login successful")
        |> redirect(to: Routes.item_path(conn, :index))

      _ ->
        conn
        |> put_flash(:info, "Wrong email or password")
        |> render("new.html")
    end
  end

  def delete(conn, _) do
    conn
    |> clear_session()
    |> redirect(to: Routes.session_path(conn, :new))
  end
end
