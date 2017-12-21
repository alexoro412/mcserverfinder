defmodule MCServerFinder.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    redis_host = Application.get_env(:mcserverfinder, :redis_host, "127.0.0.1")
    redis_port = Application.get_env(:mcserverfinder, :redis_port, 6379)
    children = [
      {MCServerFinder, [port: 4445, ip: {224,0,2,60}, redis_host: redis_host, redis_port: redis_port]},
      {RedisCleaner, [redis_host: redis_host, redis_port: redis_port]}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: MCServerFinder.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
