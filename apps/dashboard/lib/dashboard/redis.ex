defmodule Dashboard.Redis do
  use GenServer

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: RedisConn)
  end

  def init (opts) do
    {:ok, conn} = Redix.start_link(host: Keyword.get(opts, :redis_host), port: Keyword.get(opts, :redis_port))
    {:ok, conn}
  end

  def handle_call(:get_list, _from, conn) do
    {:ok, list} = Redix.command(conn, ["ZRANGEBYSCORE", "servers", "-inf", "inf"])
    {:reply, list, conn}
  end
end
