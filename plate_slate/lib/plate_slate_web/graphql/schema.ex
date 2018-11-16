defmodule PlateSlateWeb.GraphQL.Schema do

  use Absinthe.Schema

  import_types Absinthe.Phoenix.Types
  import_types __MODULE__.CommonTypes
  import_types __MODULE__.MenuTypes
  import_types __MODULE__.OrderingTypes
  import_types __MODULE__.AccountsTypes

  alias PlateSlateWeb.GraphQL.Middleware

  ### Setup common context values

  def dataloader() do
    alias PlateSlate.Menu
    Dataloader.new
    |> Dataloader.add_source(Menu, Menu.data())
  end

  def context(ctx) do
    Map.put(ctx, :loader, dataloader())
  end

  ### Plugins

  def plugins do
    [Absinthe.Middleware.Dataloader | Absinthe.Plugin.defaults]
  end

  ### Apply (common) middleware

  def middleware(middleware, field, object) do
    middleware
    |> apply(:errors, field, object)
    |> apply(:get_string, field, object)
    |> apply(:debug, field, object)
  end

  defp apply(middleware, :errors, _field, %{identifier: :mutation}) do
    middleware ++ [Middleware.ChangesetErrors]
  end
  defp apply([], :get_string, field, %{identifier: :allergy_info}) do
    [{Absinthe.Middleware.MapGet, to_string(field.identifier)}]
  end
  defp apply(middleware, :debug, _field, _object) do
    if System.get_env("PLATESLATE_GRAPHQL_DEBUG") do
      [{Middleware.Debug, :start}] ++ middleware
    else
      middleware
    end
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
    import_fields :menu_subscriptions
    import_fields :ordering_subscriptions
  end

end
