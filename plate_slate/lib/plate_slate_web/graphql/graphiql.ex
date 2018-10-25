# Use plug wrapper workaround for forwarding to same plug multiple times
# see: https://github.com/graphql-elixir/plug_graphql/issues/7

defmodule PlateSlateWeb.GraphQL.GraphiQL do
  defmodule Simple do
    use Plug.Builder
    plug Absinthe.Plug.GraphiQL, [
      schema: PlateSlateWeb.GraphQL.Schema,
      interface: :simple, # :simple | :advanced | :playground,
      json_codec: Jason,
      socket: PlateSlateWeb.UserSocket,
      # socket url resolution doesn't seem to work ...
      # so we hardcode the url here
      # https://github.com/absinthe-graphql/absinthe_plug/blob/master/lib/absinthe/plug/graphiql.ex#L415
      socket_url: "ws://localhost:4000/socket"
    ]
  end

  defmodule Advanced do
    use Plug.Builder
    plug Absinthe.Plug.GraphiQL, [
      schema: PlateSlateWeb.GraphQL.Schema,
      interface: :advanced, # :simple | :advanced | :playground,
      json_codec: Jason,
      socket: PlateSlateWeb.UserSocket,
      socket_url: "ws://localhost:4000/socket"
    ]
  end

  defmodule Playground do
    use Plug.Builder
    plug Absinthe.Plug.GraphiQL, [
      schema: PlateSlateWeb.GraphQL.Schema,
      interface: :playground, # :simple | :advanced | :playground,
      json_codec: Jason,
      socket: PlateSlateWeb.UserSocket,
      socket_url: "ws://localhost:4000/socket"
    ]
  end
end
