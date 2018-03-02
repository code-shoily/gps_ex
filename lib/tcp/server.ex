defmodule ExGps.TCP.Server do
  require Logger

  def accept(port \\ 7890) do
    {:ok, socket} =
      :gen_tcp.listen(port, [:binary, packet: :line, active: false, reuseaddr: true])

    Logger.info("Accepting connections on port: #{port}")
    loop_acceptor(socket)
  end

  defp loop_acceptor(socket) do
    {:ok, client} = :gen_tcp.accept(socket)

    {:ok, pid} =
      Task.Supervisor.start_child(ExGps.TaskSupervisor, fn ->
        {:ok, worker_pid} = ExGps.TCP.Worker.start_link(socket)
        ExGps.TCP.Worker.loop(worker_pid)
      end)

    :ok = :gen_tcp.controlling_process(client, pid)
    loop_acceptor(socket)
  end
end
