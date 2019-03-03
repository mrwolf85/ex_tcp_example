defmodule TcpExample do
  require Logger
  alias TcpExample.Handler

  def accept(port) do
    {:ok, socket} = :gen_tcp.listen(port, [:binary, packet: 0, active: false, reuseaddr: true])

    Logger.info("Accepting connections on port #{port}")
    loop_acceptor(socket)
  end

  defp loop_acceptor(socket) do
    {:ok, client} = :gen_tcp.accept(socket)
    Logger.info("Accpeted new connection")

    {:ok, pid} =
      DynamicSupervisor.start_child(TcpExample.Handler.DynamicSupervisor, %{
        id: Handler,
        start: {Handler, :start_link, [%{socket: client}, []]},
        type: :worker,
        restart: :transient
      })

    :gen_tcp.controlling_process(client, pid)
    loop_acceptor(socket)
  end
end
