defmodule Project.WorkerSupervisor2 do
    use DynamicSupervisor

    def start_link(_) do
        DynamicSupervisor.start_link(__MODULE__, :no_args, name: {:global, :workersupervisor2})
    end

    def init(:no_args) do
        IO.puts("#{inspect self()}   2 spwaned here")
        DynamicSupervisor.init(strategy: :one_for_one)
    end

    def add_worker(number) do
        specs={Project.VampireWorkers2, number + 500}
        {:ok, _pid} = DynamicSupervisor.start_child({:global, :workersupervisor2}, specs)
    end

    def stopWorkerSupervisor() do
        {:stop, :normal, []}
    end

end
