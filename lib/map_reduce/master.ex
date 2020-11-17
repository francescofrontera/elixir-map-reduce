defmodule Master do
  use GenServer
  @me Master

  @vsn "0"



  def start_link(p_and_fun) do
    GenServer.start_link(__MODULE__, p_and_fun, name: @me)
  end

  def done(), do: GenServer.cast(@me, :well_done)

  def init(ops) do
    Process.send_after(self(), :start_reader, 0)
    {:ok, ops}
  end

  def handle_info(:start_reader, {parallelism, m_func, r_func}) do
    1..parallelism
    |> Enum.each(fn _ -> Master.Slave.Supervisor.spawn_slave({m_func, r_func}) end)

    {:noreply, parallelism}
  end

  def handle_cast(:well_done, _p = 1) do
    IO.puts(inspect(Master.Resulter.get()))
    IO.puts("Job Finish")
    System.halt(0)
  end

  def handle_cast(:well_done, p), do: {:noreply, p - 1}
end
