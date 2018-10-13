# MC LAN Server Finder

This program listens for Minecraft LAN servers, and provides a web dashboard listing them.

## Configuration

Edit config/config.exs with the following

```elixir
config :mcserverfinder,
  redis_host: "127.0.0.1",
  redis_port: 6379,
  interval: 10

config :dashboard,
  redis_host: "127.0.0.1",
  redis_port: 6379
```

## Running

To run a full node, w/ web interface: `mix phx.server`

To just run a scanner node: `mix run --no-halt`
