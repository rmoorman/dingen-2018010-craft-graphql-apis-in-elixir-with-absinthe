defmodule PlateSlateWeb.GraphQL.Schema.OrderingTypes do

  use Absinthe.Schema.Notation

  alias PlateSlateWeb.GraphQL.Resolvers

  ###

  object :order do
    field :id, :id
    field :customer_number, :integer
    field :items, list_of(:order_item)
    field :state, :string
  end

  object :order_item do
    field :name, :string
    field :quantity, :integer
  end

  ### Mutations

  input_object :order_item_input do
    field :menu_item_id, non_null(:id)
    field :quantity, non_null(:integer)
  end

  input_object :place_order_input do
    field :customer_number, :integer
    field :items, non_null(list_of(non_null(:order_item_input)))
  end

  object :order_result do
    field :order, :order
    field :errors, list_of(:input_error)
  end

  object :ordering_mutations do
    field :place_order, :order_result do
      arg :input, non_null(:place_order_input)
      resolve &Resolvers.Ordering.place_order/3
    end

    field :ready_order, :order_result do
      arg :id, non_null(:id)
      resolve &Resolvers.Ordering.ready_order/3
    end

    field :complete_order, :order_result do
      arg :id, non_null(:id)
      resolve &Resolvers.Ordering.complete_order/3
    end
  end

  ### Subscriptions

  object :ordering_subscriptions do
    field :new_order, :order do
      config fn _args, _info ->
        {:ok, topic: "*"}
      end

      # The root is given when the subscription is published ...
      # so no need to resolve it. One could, however, inspect
      # the pushed root like this though:
      #resolve fn root, _, _ ->
      #  IO.inspect(root, label: "root of subscription newOrder")
      #  {:ok, root}
      #end
    end

    field :update_order, :order do
      arg :id, non_null(:id)

      config fn args, _info ->
        {:ok, topic: args.id}
      end

      trigger [:ready_order, :complete_order], topic: fn
        %{order: order} -> [order.id]
        _ -> []
      end

      # Because the complete_order and ready_order mutations
      # do not just return the order but also error information
      # and for this subscription, we only need the order itself
      # we do a little unwrapping
      resolve fn %{order: order}, _, _ ->
        {:ok, order}
      end
    end
  end

end