defmodule MapReduce do
  @moduledoc """
  Documentation for `MapReduce`.
  """
  @doc """
  ## Examples
  MapReduce.map_and_reduce("files/words.txt", fn line -> String.split(line, " ") |> Enum.map(fn word -> { String.trim(word, "\n"), 1 } end) end, fn old, new -> old + new end)
  """
  def map_and_reduce(file_path, map_fun, reduce_f, parrallelims \\ 6) do
    File.Reader.start_link(file_path)
    Master.start_link({parrallelims, map_fun, reduce_f})
  end
end
