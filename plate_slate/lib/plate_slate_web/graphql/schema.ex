defmodule PlateSlateWeb.GraphQL.Schema do

  use Absinthe.Schema

  import_types __MODULE__.CommonTypes
  import_types __MODULE__.MenuTypes
  import_types __MODULE__.OrderingTypes
  import_types __MODULE__.AccountsTypes

  alias PlateSlateWeb.GraphQL.Middleware

  ### Apply (common) middleware

  def middleware(middleware, field, object) do
    middleware
    |> apply(:errors, field, object)
    |> apply(:get_string, field, object)
  end


  defp apply(middleware, :errors, _field, %{identifier: :mutation}) do
    middleware ++ [Middleware.ChangesetErrors]
  end
  defp apply([], :get_string, field, %{identifier: :allergy_info}) do
    [{Absinthe.Middleware.MapGet, to_string(field.identifier)}]
  end
  defp apply(middleware, _, _, _) do
    middleware
  end

  ###
  ### Queries
  ###

  query do
    import_fields :menu_queries
    import_fields :accounts_queries

    @desc "Email filtering"
    field :accept_only_valid_email_list, list_of(:email) do
      arg :email_list, non_null(list_of(:email))
      resolve fn _, args, _ -> {:ok, args.email_list} end
    end
  end

  ###
  ### Mutations
  ###

  mutation do
    import_fields :menu_mutations
    import_fields :ordering_mutations
    import_fields :accounts_mutations
  end

  ###
  ### Subscriptions
  ###

  subscription do
    import_fields :ordering_subscriptions
  end

end
