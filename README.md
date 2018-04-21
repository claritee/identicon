# Identicon

**TODO: Add description**

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `identicon` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:identicon, "~> 0.1.0"}
  ]
end
```

## Notes

### EGD - Erlang Graphical Drawer

`:egd` is no longer available in Elixir OTP, so to get around this

mix.exs:

```
{:egd, github: "erlang/egd"}
```

To install dependencies:

```
mix deps.clean --all
mix deps.get
mix deps.compile
```

### Generate docs

mix.exs:

```
{:ex_doc, "~> 0.12"}
```

```
mix docs
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/identicon](https://hexdocs.pm/identicon).

