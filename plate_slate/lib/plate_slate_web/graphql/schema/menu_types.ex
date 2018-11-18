defmodule PlateSlateWeb.GraphQL.Schema.MenuTypes do

  use Absinthe.Schema.Notation
  use Absinthe.Relay.Schema.Notation, :modern

  import Absinthe.Resolution.Helpers, only: [dataloader: 2]

  alias PlateSlateWeb.GraphQL.Resolvers
  alias PlateSlateWeb.GraphQL.Middleware

  alias PlateSlate.Menu


  @desc "Filtering options for the menu item list"
  input_object :menu_item_filter do
    @desc "Matching a name"
    field :name, :string

    @desc "Matching a category name"
    field :category, :string

    @desc "Matching a tag"
    field :tag, :string

    @desc "Priced above a value"
    field :priced_above, :decimal

    @desc "Priced below a value"
    field :priced_below, :decimal

    @desc "Added to the menu before this date"
    field :added_before, :date

    @desc "Added to the menu after this date"
    field :added_after, :date
  end


  @desc "A tasty dish for you to enjoy"
  node object :menu_item do
    interfaces [:search_result]

    #@desc "The identifier for this menu item"
    #field :id, :id

    @desc "The name of the menu item"
    field :name, :string

    @desc "A small amount of text trying to describe this tasteful experience"
    field :description, :string

    @desc "The price of the item"
    field :price, :decimal

    @desc "Since when it has been on the menu"
    field :added_on, :date

    field :allergy_info, list_of(:allergy_info)

    field :category, :category do
      resolve dataloader(Menu, :category)
    end

    field :order_history, :order_history do
      arg :since, :date
      middleware Middleware.Authorize, "employee"
      resolve &Resolvers.Ordering.order_history/3
    end
  end


  object :order_history do
    field :orders, list_of(:order) do
      resolve &Resolvers.Ordering.orders/3
    end

    field :quantity, non_null(:integer) do
      resolve Resolvers.Ordering.stat(:quantity)
    end

    @desc "Gross Revenue"
    field :gross, non_null(:float) do
      resolve Resolvers.Ordering.stat(:gross)
    end
  end


  object :allergy_info do
    field :allergen, :string
    field :severity, :string
  end


  @desc "Category for dishes"
  object :category do
    interfaces [:search_result]
    @desc "The identifier for this category"
    field :id, :id
    @desc "The name of the category"
    field :name, :string
    field :description, :string
    field :items, list_of(:menu_item) do
      arg :filter, :menu_item_filter
      arg :order, type: :sort_order, default_value: :asc
      resolve dataloader(Menu, :items)
    end
  end


  interface :search_result do
    field :name, :string
    resolve_type fn
      %PlateSlate.Menu.Item{}, _ -> :menu_item
      %PlateSlate.Menu.Category{}, _ -> :category
      _, _ -> nil
    end
  end

  # Relay connection node definition
  connection node_type: :menu_item

  ###
  ### Queries
  ###

  object :menu_queries do
    @desc "The list of available items on the menu"
    connection field :menu_items, node_type: :menu_item do
      arg :filter, :menu_item_filter
      arg :order, type: :sort_order, default_value: :asc
      resolve &Resolvers.Menu.menu_items/3
    end

    field :menu_item, :menu_item do
      arg :id, non_null(:id)
      resolve &Resolvers.Menu.get_item/3
    end

    @desc "The list of available categories"
    field :category_list, list_of(:category) do
      @desc "The name of the category"
      arg :name, :string
      arg :order, type: :sort_order, default_value: :asc
      resolve &Resolvers.Menu.category_list/3
    end

    field :search, list_of(:search_result) do
      arg :matching, non_null(:string)
      resolve &Resolvers.Menu.search/3
    end
  end

  ###
  ### Mutations
  ###

  input_object :create_menu_item_input do
    field :name, non_null(:string)
    field :description, :string
    field :price, non_null(:decimal)
    field :category_id, non_null(:id)
  end

  object :menu_item_result do
    field :menu_item, :menu_item
    field :errors, list_of(:input_error)
  end

  input_object :update_menu_item_input do
    field :name, :string
    field :description, :string
    field :price, :decimal
    field :category_id, :id
  end


  object :menu_mutations do
    field :create_menu_item, :menu_item_result do
      arg :input, non_null(:create_menu_item_input)
      middleware Middleware.Authorize, "employee"
      resolve &Resolvers.Menu.create_item/3
    end

    field :update_menu_item, :menu_item_result do
      arg :id, :id
      arg :input, non_null(:update_menu_item_input)
      resolve &Resolvers.Menu.update_item/3
    end
  end

  ###
  ### Subscriptions
  ###

  object :menu_subscriptions do
    field :new_menu_item, :menu_item do
      config fn _args, _info ->
        {:ok, topic: "*"}
      end
    end
  end
end
