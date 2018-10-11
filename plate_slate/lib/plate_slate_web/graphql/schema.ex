defmodule PlateSlateWeb.GraphQL.Schema do
  use Absinthe.Schema

  alias PlateSlateWeb.GraphQL.Resolvers

  query do
    @desc "The list of available items on the menu"
    field :menu_items, list_of(:menu_item) do
      arg :matching, :string
      arg :order, type: :sort_order, default_value: :asc
      resolve &Resolvers.Menu.menu_items/3
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

  enum :sort_order do
    value :asc
    value :desc
  end
end
