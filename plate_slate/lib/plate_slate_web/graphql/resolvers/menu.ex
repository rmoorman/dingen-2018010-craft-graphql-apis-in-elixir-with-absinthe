defmodule PlateSlateWeb.GraphQL.Resolvers.Menu do

  import Absinthe.Resolution.Helpers, only: [async: 1]

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

  def category_for_item(menu_item, _, _) do
    async(fn ->
      query = Ecto.assoc(menu_item, :category)
      {:ok, Repo.one(query)}
    end)
    |> IO.inspect()
  end

  def search(_, %{matching: term}, _) do
    {:ok, Menu.search(term)}
  end

  def create_item(_, %{input: params}, _) do
    with {:ok, menu_item} <- Menu.create_item(params) do
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
      {:get, nil} ->
        {:ok, %{errors: [%{key: "", message: ["invalid item"]}]}}
      {:update, error} ->
        error
    end
  end

end
