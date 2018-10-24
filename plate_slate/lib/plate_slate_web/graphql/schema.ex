defmodule PlateSlateWeb.GraphQL.Schema do

  use Absinthe.Schema

  import_types __MODULE__.CommonTypes
  import_types __MODULE__.MenuTypes

  query do
    import_fields :menu_queries

    @desc "Email filtering"
    field :accept_only_valid_email_list, list_of(:email) do
      arg :email_list, non_null(list_of(:email))
      resolve fn _, args, _ -> {:ok, args.email_list} end
    end
  end

end
