defmodule Master.Resulter do
  use GenServer

  @me Resulter

  def start_link(_),
    do: GenServer.start_link(__MODULE__, :ok, name: @me)

  def combine(partial_result),
    do: GenServer.cast(@me, {:combine, partial_result})

  def get,
    do: GenServer.call(@me, :get_combined_map)

  def init(:ok),
    do: {:ok, %{}}

  def handle_cast({:combine, partial_result}, acc),
    do: {:noreply, Map.merge(Enum.into(partial_result, %{}), acc)}

  def handle_call(:get_combined_map, _from, acc) do
    top_ten_word = acc |> Enum.filter(&(elem(&1, 1) > 1))

    {:reply, top_ten_word, %{}}
  end
end
