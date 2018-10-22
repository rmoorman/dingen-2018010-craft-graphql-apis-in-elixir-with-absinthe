defmodule PlateSlateWeb.GraphQL.Schema do
  use Absinthe.Schema

  alias PlateSlateWeb.GraphQL.Resolvers

  query do
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

    @desc "Email filtering"
    field :accept_only_valid_email_list, list_of(:email) do
      arg :email_list, non_null(list_of(:email))
      resolve fn _, args, _ -> {:ok, args.email_list} end
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
    field :added_on, :date
  end

  @desc "Category for dishes"
  object :category do
    @desc "The identifier for this category"
    field :id, :id

    @desc "The name of the category"
    field :name, :string
  end

  enum :sort_order do
    value :asc
    value :desc
  end

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

  scalar :date do
    parse fn input ->
      with(
        %Absinthe.Blueprint.Input.String{value: value} <- input,
        {:ok, date} <- Date.from_iso8601(value)
      ) do
        {:ok, date}
      else
        _ -> :error
      end
    end

    serialize fn date ->
      Date.to_iso8601(date)
    end
  end

  scalar :email do
    parse fn input ->
      with(
        %Absinthe.Blueprint.Input.String{value: value} <- input,
        [username, domain] <- String.split(value, "@")
      ) do
        {:ok, {username, domain}}
      else
        _ -> :error
      end
    end

    serialize fn {username, domain} ->
      "#{username}@#{domain}"
    end
  end
end
