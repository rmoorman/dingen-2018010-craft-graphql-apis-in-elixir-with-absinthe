# Absinthe.Schema "caches" the built schema inside the process dictionary

So doing the following in iex
~~~
Absinthe.Schema.lookup_type(PlateSlateWeb.Schema, "MenuItem")
~~~
and then adjusting the schema and calling `recompile/1` does not have any
effect on the currently running iex session. You either have to
`Process.exit(self(), :exit_please)` in order to get a fresh shell process or
clean the process dictionary with
`:erlang.erase({PlateSlateWeb.Schema, "MenuItem"})`
