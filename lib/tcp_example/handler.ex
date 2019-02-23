defmodule TcpExample.Handler do
  use GenServer
  require Logger

  def start_link(args, options) do
    GenServer.start_link(__MODULE__, args, options)
  end

  @impl true
  def init(args) do
    socket = Map.get(args, :socket)
    :inet.setopts(socket, active: true)
    {:ok, %{socket: socket}}
  end

  @impl true
  def handle_info({:tcp, socket, packet}, state) do
    Logger.info("Received packet: #{inspect(packet)} and send response")
    :gen_tcp.send(socket, "Hi from tcp server \n")
    {:noreply, state}
  end

  @impl true
  def handle_info({:tcp_closed, _socket}, state) do
    Logger.info("Socket is closed")
    {:noreply, state}
  end

  @impl true
  def handle_info({:tcp_error, _socket, reason}, state) do
    Logger.error("Tcp error: #{inspect(reason)}")
    {:noreply, state}
  end
end
