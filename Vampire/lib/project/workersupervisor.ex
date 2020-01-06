defmodule Project.WorkerSupervisor do
    use DynamicSupervisor

    def start_link(_) do
        DynamicSupervisor.start_link(__MODULE__, :no_args, name: __MODULE__)
    end

    def init(:no_args) do
        DynamicSupervisor.init(strategy: :one_for_one)
    end

    def add_worker(number) do
        specs={Project.VampireWorkers, number }
        {:ok, _pid} = DynamicSupervisor.start_child(__MODULE__, specs)
    end

end
