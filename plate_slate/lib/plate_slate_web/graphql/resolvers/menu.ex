defmodule PlateSlateWeb.GraphQL.Resolvers.Menu do

  alias PlateSlate.Menu
  alias PlateSlate.Repo

  def menu_items(_, args, _) do
    {:ok, Menu.list_items(args)}
  end

  def category_list(_, args, _) do
    {:ok, Menu.list_categories(args)}
  end

  def items_for_category(category, _, _) do
    query = Ecto.assoc(category, :items)
    {:ok, Repo.all(query)}
  end

  def search(_, %{matching: term}, _) do
    {:ok, Menu.search(term)}
  end

  def create_item(_, %{input: params}, _) do
    case Menu.create_item(params) do
      {:error, changeset} ->
        {:ok, %{errors: transform_errors(changeset)}}
      {:ok, menu_item} ->
        {:ok, %{menu_item: menu_item}}
    end
  end

  def update_item(_, %{id: id, input: params}, _) do
    with(
      {:get, menu_item} when not is_nil(menu_item) <- {:get, Menu.get_item(id)},
      {:update, {:ok, menu_item}} <- {:update, Menu.update_item(menu_item, params)}
    ) do
      {:ok, %{menu_item: menu_item}}
    else
      {:update, {:error, %Ecto.Changeset{} = changeset}} ->
        {:ok, %{errors: transform_errors(changeset)}}
      _ ->
        {:ok, %{errors: [%{key: "", message: ["invalid item"]}]}}
    end
  end


  defp transform_errors(changeset) do
    changeset
    |> Ecto.Changeset.traverse_errors(&format_error/1)
    |> Enum.map(fn {key, value} ->
      %{key: key, message: value}
    end)
  end

  @spec format_error(Ecto.Changeset.error) :: String.t
  defp format_error({msg, opts}) do
    Enum.reduce(opts, msg, fn {key, value}, acc ->
      String.replace(acc, "%{#{key}}", to_string(value))
    end)
  end

end
