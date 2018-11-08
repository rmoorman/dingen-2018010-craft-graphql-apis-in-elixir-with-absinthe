defmodule PlateSlate.Repo.Migrations.CreateOrderItemView do
  use Ecto.Migration

  def up do
    execute("""
    CREATE VIEW
      order_item_view
    AS
      SELECT
        i.*, o.id AS order_id
      FROM
        orders AS o,
        json_b_to_recordset(o.items) AS i(name text, quantity int, price flat, id text)
    """)
  end

  def down do
    execute("DROP VIEW order_item_view")
  end
end
