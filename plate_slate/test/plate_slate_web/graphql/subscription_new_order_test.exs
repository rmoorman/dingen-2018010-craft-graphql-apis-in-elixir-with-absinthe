defmodule PlateSlateWeb.GraphQL.Subscription.NewOrderTest do

  use PlateSlateWeb.SubscriptionCase

  alias PlateSlate.TestAccountsFactory

  @subscription """
  subscription {
    newOrder { customerNumber }
  }
  """
  @mutation """
  mutation ($input: PlaceOrderInput!) {
    placeOrder(input: $input) { order { id } }
  }
  """
  @login """
  mutation ($email: String!, $role: Role!, $password: String!) {
    login(role: $role, email: $email, password: $password) {
      token
    }
  }
  """
  test "new orders can be subscribed to", %{socket: socket} do
    # login
    user = TestAccountsFactory.create_user("employee")
    ref = push_doc socket, @login, variables: %{
      "email" => user.email,
      "role" => "EMPLOYEE",
      "password" => "super-secret",
    }
    assert_reply ref, :ok, %{data: %{"login" => %{"token" => _}}}, 1_000

    # setup a subscription
    ref = push_doc socket, @subscription
    assert_reply ref, :ok, %{subscriptionId: subscription_id}

    # run a mutation to trigger the subscription
    order_input = %{
      "customerNumber" => 24,
      "items" => [
        %{"menuItemId" => menu_item("Reuben").id, "quantity" => 2},
      ]
    }
    ref = push_doc socket, @mutation, variables: %{"input" => order_input}
    assert_reply ref, :ok, reply
    assert %{data: %{"placeOrder" => %{"order" => %{"id" => _}}}} = reply

    # check to see if we got subscription data
    expected = %{
      result: %{data: %{"newOrder" => %{"customerNumber" => 24}}},
      subscriptionId: subscription_id,
    }
    assert_push "subscription:data", push
    assert expected == push
  end
end
