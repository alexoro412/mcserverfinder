defmodule MCServerFinder do
  use GenServer

	def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, opts, opts)
	end

	def init(opts) do
		{:ok, sock} = :gen_udp.open(Keyword.get(opts, :port),
			[{:reuseaddr, true},
			 {:ip, Keyword.get(opts, :ip)},
			 {:multicast_ttl, 4},
       {:multicast_loop, false},
       :binary,
       {:active, true},
       {:add_membership, { Keyword.get(opts, :ip), {0,0,0,0} }}])
    {:ok, conn} = Redix.start_link(host: Keyword.get(opts, :redis_host), port: Keyword.get(opts, :redis_port))
    {:ok, {sock, conn}}
	end

	def handle_info({:udp, _sock, {i1,i2,i3,i4}, _inport, packet}, {sock, conn}) do
    time = System.os_time(:seconds)
    case Regex.run(~r/\[MOTD\]([^\[]+)\[\/MOTD\]\[AD\](\d+)\[\/AD\]/, packet) do
			nil ->
				IO.puts(packet)
				{:noreply, {sock, conn}}
			[_, motd, port] ->
        key_name = "mc:#{i1}.#{i2}.#{i3}.#{i4}:#{port}:#{motd}"
        IO.puts key_name
        {:ok, _} = Redix.command(conn, ["ZADD", "servers", time, key_name])
				{:noreply, {sock, conn}}
		end
	end

  def handle_info(r, state) do
    IO.puts (inspect r)
    {:noreply, state}
  end
end
