defmodule Master.Slave.Supervisor do
  use DynamicSupervisor

  @me Supervisor

  def start_link(_),
  do: DynamicSupervisor.start_link(__MODULE__, :ok, name: @me)


  def init(:ok),
  do: DynamicSupervisor.init(strategy: :one_for_one)


  @spec children :: [{:undefined, :restarting | pid, :supervisor | :worker, any}]
  def children,
  do: DynamicSupervisor.which_children(@me)

  def count_childer,
  do: DynamicSupervisor.count_children(@me)

  def spawn_slave(functions) do
    worker_spec = { Master.Slave, functions }

    DynamicSupervisor.start_child(@me, worker_spec)
  end
end
