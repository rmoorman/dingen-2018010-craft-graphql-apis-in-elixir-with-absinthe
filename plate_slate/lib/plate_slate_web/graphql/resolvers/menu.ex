defmodule PlateSlateWeb.GraphQL.Resolvers.Menu do

  import Absinthe.Resolution.Helpers, only: [on_load: 2]

  alias PlateSlate.Menu
  #alias PlateSlate.Repo

  def menu_items(_, args, _) do
    {:ok, Menu.list_items(args)}
  end

  def category_list(_, args, _) do
    {:ok, Menu.list_categories(args)}
  end

  def items_for_category(category, args, %{context: %{loader: loader}}) do
    loader
    |> Dataloader.load(Menu, {:items, args}, category)
    |> on_load(fn loader ->
      items = Dataloader.get(loader, Menu, {:items, args}, category)
      {:ok, items}
    end)
  end

  def category_for_item(menu_item, _, %{context: %{loader: loader}}) do
    loader
    |> Dataloader.load(Menu, :category, menu_item)
    |> on_load(fn loader ->
      category = Dataloader.get(loader, Menu, :category, menu_item)
      {:ok, category}
    end)
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
