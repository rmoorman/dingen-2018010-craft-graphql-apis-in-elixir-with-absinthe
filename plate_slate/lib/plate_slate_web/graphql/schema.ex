defmodule PlateSlateWeb.GraphQL.Schema do
  use Absinthe.Schema

  alias PlateSlate.Repo
  alias PlateSlate.Menu

  query do
    @desc "The list of available items on the menu"
    field :menu_items, list_of(:menu_item) do
      resolve fn _, _, _ ->
        {:ok, Repo.all(Menu.Item)}
      end
    end
  end

  @desc "A tasty dish for you to enjoy"
  object :menu_item do
    @desc "The identifier for this menu item"
    field :id, :id

    @desc "The name of the menu item"
    field :name, :string

    @desc "A small amount of text trying to describe this tasteful experience"
    field :description, :string

    @desc "Since when it has been on the menu"
    field :added_on, :string
  end
end