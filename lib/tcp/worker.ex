defmodule ExGps.TCP.Worker do
  use ExActor.GenServer

  defstart start_link(socket) do
    initial_state(%{socket: socket})
  end

  defcast loop, state: %{socket: socket} do
    serve(socket)
  end

  defp serve(socket) do
    socket
    |> read_line()
    |> write_line(socket)

    serve(socket)
    :reply
  end

  defp read_line(socket) do
    {:ok, data} = :gen_tcp.recv(socket, 0)
    data
  end

  defp write_line(line, socket) do
    :gen_tcp.send(socket, line)
  end
end
