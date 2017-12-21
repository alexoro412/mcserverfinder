defmodule RedisCleaner do
  use GenServer

  @interval 10 * 1000

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts)
  end

  def init(opts) do
    {:ok, conn} = Redix.start_link(host: Keyword.get(opts, :redis_host), port: Keyword.get(opts, :redis_port))
    schedule()
    {:ok, conn}
  end

  defp schedule() do
    Process.send_after(self(), :clean, @interval)
  end

  def handle_info(:clean, conn) do
    time = System.os_time(:seconds)
    {:ok, _} = Redix.command(conn, ["ZREMRANGEBYSCORE", "servers", "-inf", "(#{time-2}"])
    schedule()
    {:noreply, conn}
  end
end
