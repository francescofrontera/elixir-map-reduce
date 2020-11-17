defmodule File.Reader do
  use GenServer

  @me Reader

  def start_link(path),
    do: GenServer.start_link(__MODULE__, path, name: @me)

  def next_line(),
    do: GenServer.call(@me, :next_line)

  def init(file_path) do
    Process.send_after(self(), :start_read, 0)
    {:ok, file_path}
  end

  def handle_info(:start_read, path),
    do: {:noreply, File.open!(path, [:read, :utf8])}

  def handle_call(:next_line, _from, file),
    do: {:reply, IO.read(file, :line), file}
end
