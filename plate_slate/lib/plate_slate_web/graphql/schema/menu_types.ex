defmodule PlateSlateWeb.GraphQL.Schema.MenuTypes do
  use Absinthe.Schema.Notation

  alias PlateSlateWeb.GraphQL.Resolvers

  @desc "Filtering options for the menu item list"
  input_object :menu_item_filter do
    @desc "Matching a name"
    field :name, :string

    @desc "Matching a category name"
    field :category, :string

    @desc "Matching a tag"
    field :tag, :string

    @desc "Priced above a value"
    field :priced_above, :float

    @desc "Priced below a value"
    field :priced_below, :float

    @desc "Added to the menu before this date"
    field :added_before, :date

    @desc "Added to the menu after this date"
    field :added_after, :date
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
    field :added_on, :date
  end

  @desc "Category for dishes"
  object :category do
    @desc "The identifier for this category"
    field :id, :id
    @desc "The name of the category"
    field :name, :string
    field :description, :string
    field :items, list_of(:menu_item) do
      resolve &Resolvers.Menu.items_for_category/3
    end
  end

  union :search_result do
    types [:menu_item, :category]
    resolve_type fn
      %PlateSlate.Menu.Item{}, _ -> :menu_item
      %PlateSlate.Menu.Category{}, _ -> :category
      _, _ -> nil
    end
  end

  object :menu_queries do
    @desc "The list of available items on the menu"
    field :menu_items, list_of(:menu_item) do
      arg :filter, non_null(:menu_item_filter)
      arg :order, type: :sort_order, default_value: :asc
      resolve &Resolvers.Menu.menu_items/3
    end

    @desc "The list of available categories"
    field :category_list, list_of(:category) do
      @desc "The name of the category"
      arg :name, :string
      arg :order, type: :sort_order, default_value: :asc
      resolve &Resolvers.Menu.category_list/3
    end
  end
end
