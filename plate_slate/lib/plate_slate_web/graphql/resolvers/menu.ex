defmodule PlateSlateWeb.GraphQL.Resolvers.Menu do

  alias PlateSlate.Menu

  import Absinthe.Resolution.Helpers, only: [on_load: 2]

  def menu_items(_, args, _) do
    Absinthe.Relay.Connection.from_query(
      Menu.list_items_query(args),
      &PlateSlate.Repo.all/1,
      args
    )
  end

  def category_list(_, args, _) do
    {:ok, Menu.list_categories(args)}
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

  def get_item(_, %{id: id}, %{context: %{loader: loader}}) do
    loader
    |> Dataloader.load(Menu, Menu.Item, id)
    |> on_load(fn loader ->
      {:ok, Dataloader.get(loader, Menu, Menu.Item, id)}
    end)
  end

end
