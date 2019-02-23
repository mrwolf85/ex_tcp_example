defmodule TcpExample.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      {DynamicSupervisor, strategy: :one_for_one, name: TcpExample.Handler.DynamicSupervisor},
      {Task, fn -> TcpExample.accept(Application.get_env(:tcp_example, :port)) end}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: TcpExample.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
