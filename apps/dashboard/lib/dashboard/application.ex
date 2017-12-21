defmodule Dashboard.Application do
  use Application

  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec

    # Define workers and child supervisors to be supervised
    children = [
      # Start the endpoint when the application starts
      supervisor(DashboardWeb.Endpoint, []),
      # worker(Dashboard.Redis, [redis_host: "127.0.0.1", redis_port: 6379])
      {Dashboard.Redis, [redis_host: Application.get_env(:dashboard, :redis_host), redis_port: Application.get_env(:dashboard, :redis_port)]}
      # Start your own worker by calling: Dashboard.Worker.start_link(arg1, arg2, arg3)
      # worker(Dashboard.Worker, [arg1, arg2, arg3]),
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Dashboard.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    DashboardWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
