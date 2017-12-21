defmodule DashboardWeb.PageController do
  use DashboardWeb, :controller

  def index(conn, _params) do
    list = GenServer.call(RedisConn, :get_list)
    # list = ["mc:10.80.9.100:59850:Jackson_20 - New World", "mc:10.80.6.151:60845:norkie252 - KDS Minecraft"]
    new_list = Enum.map(list, &(String.split(&1, ":")))
    render conn, "index.html", servers: new_list
  end
end
