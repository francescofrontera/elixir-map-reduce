# Play with Elixir 

A simple no-prod-ready implementation of The Map-Reduce Algorithm using Elixir, which is inspired by Druper exercise in the book `Programming Elixir 1.6`.

### Example
```
shell> iex -S mix
Erlang/OTP 23 [erts-11.1] [source] [64-bit] [smp:12:12] [ds:12:12:10] [async-threads:1] [hipe] [dtrace]

Compiling 7 files (.ex)
Generated map_reduce app
Interactive Elixir (1.10.4) - press Ctrl+C to exit (type h() ENTER for help)

iex(1)> MapReduce.map_and_reduce(
...(1)>     "files/words.txt",
...(1)>      fn line -> String.split(line, " ") |> Enum.map(fn word -> { String.trim(word, "\n"), 1 } end) end,
...(1)>       fn old, new -> old + new end
...(1)>       )

{:ok, #PID<0.252.0>}

{"Amurath", 2}, {"wicked?", 2}, {"Venetia,", 2}, {"IS", 2}, {"horrible!", 3}, {...}, ...]
Job Finish

```
