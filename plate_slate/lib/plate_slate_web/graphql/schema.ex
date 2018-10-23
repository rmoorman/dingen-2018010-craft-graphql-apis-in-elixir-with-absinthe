defmodule PlateSlateWeb.GraphQL.Schema do
  use Absinthe.Schema

  import_types __MODULE__.MenuTypes

  alias PlateSlateWeb.GraphQL.Resolvers

  query do
    import_fields :menu_queries

    @desc "Email filtering"
    field :accept_only_valid_email_list, list_of(:email) do
      arg :email_list, non_null(list_of(:email))
      resolve fn _, args, _ -> {:ok, args.email_list} end
    end

    field :search, list_of(:search_result) do
      arg :matching, non_null(:string)
      resolve &Resolvers.Menu.search/3
    end
  end

  enum :sort_order do
    value :asc
    value :desc
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
