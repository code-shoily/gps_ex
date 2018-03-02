defmodule ExGps.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      # Starts a worker by calling: ExGps.Worker.start_link(arg)
      # {ExGps.Worker, arg},
      {Task.Supervisor, name: ExGps.TaskSupervisor},
      {Task, fn -> ExGps.TCP.Server.accept(4040) end}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ExGps.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
