defmodule Master.Slave do
  use GenServer, restart: :transient

  ## Public API
  def start_link(opsf),
    do: GenServer.start_link(__MODULE__, opsf)

  ## Private API
  def init(opsf) do
    Process.send_after(self(), :map, 0)
    {:ok, opsf}
  end

  def handle_info(:map, all_f = {map_func, red_func}) do
    case File.Reader.next_line() do
      line when is_binary(line) ->
        map_work(line, map_func) |> reduce_work(red_func) |> Master.Resulter.combine()
        send(self(), :map)

      :eof ->
        Master.done()
    end

    {:noreply, all_f}
  end

  defp map_work(line, m_f),
    do: Task.async(fn -> m_f.(line) end) |> Task.await()

  defp reduce_work(to_reduce, r_f) do
    work =
      Task.async(fn ->
        to_reduce
        |> Enum.group_by(&elem(&1, 0), &elem(&1, 1))
        |> Enum.map(fn {key, value} ->
          {key, Enum.reduce(value, fn x, acc -> r_f.(acc, x) end)}
        end)
      end)

    Task.await(work)
  end
end
