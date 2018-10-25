defmodule PlateSlateWeb.GraphQL.Schema.CreateMenuItemTest do

  use PlateSlateWeb.ConnCase, async: true

  alias PlateSlate.{Repo, Menu}
  import Ecto.Query

  @api "/api/graphql"

  setup do
    PlateSlate.TestSeeds.run()

    category_id =
      from(t in Menu.Category, where: t.name == "Sandwiches")
      |> Repo.one!
      |> Map.fetch!(:id)
      |> to_string

    {:ok, category_id: category_id}
  end


  @query """
  mutation ($menuItem: MenuItemInput!) {
    createMenuItem(input: $menuItem) {
      menuItem {
        name
        description
        price
      }
      errors {
        key
        message
      }
    }
  }
  """

  test "createMenuItem field creates an item", %{category_id: category_id} do
    menu_item = %{
      "name" => "French Dip",
      "description" => "Roast beef, caramelized onions, horseradish, ...",
      "price" => "5.75",
      "categoryId" => category_id,
    }
    conn = post(build_conn(), @api, query: @query, variables: %{"menuItem" => menu_item})

    assert json_response(conn, 200) == %{
      "data" => %{
        "createMenuItem" => %{
          "menuItem" => %{
            "name" => menu_item["name"],
            "description" => menu_item["description"],
            "price" => menu_item["price"],
          },
          "errors" => nil,
        }
      }
    }
  end

  test "creating a menu item with an existing name fails", %{category_id: category_id} do
    menu_item = %{
      "name" => "Reuben",
      "description" => "Roast beef, caramelized onions, horseradish, ...",
      "price" => "5.75",
      "categoryId" => category_id,
    }
    conn = post(build_conn(), @api, query: @query, variables: %{"menuItem" => menu_item})

    assert json_response(conn, 200) == %{
      "data" => %{
        "createMenuItem" => %{
          "menuItem" => nil,
          "errors" => [
            %{"key" => "name", "message" => "has already been taken"},
          ],
        },
      },
    }
  end

end
