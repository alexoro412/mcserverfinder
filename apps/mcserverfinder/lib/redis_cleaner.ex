defmodule RedisCleaner do
  use GenServer

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts)
  end

  def init(opts) do
    {:ok, conn} = Redix.start_link(host: Keyword.get(opts, :redis_host), port: Keyword.get(opts, :redis_port))
    schedule()
    interval = Keyword.get(opts, :interval)
    {:ok, {conn, interval}}
  end

  defp schedule(interval) do
    Process.send_after(self(), :clean, interval * 1000)
  end

  def handle_info(:clean, {conn, interval}) do
    time = System.os_time(:seconds)
    {:ok, _} = Redix.command(conn, ["ZREMRANGEBYSCORE", "servers", "-inf", "(#{time-2}"])
    schedule(interval)
    {:noreply, {conn, interval}}
  end
end
