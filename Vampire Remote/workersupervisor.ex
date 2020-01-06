defmodule Project.WorkerSupervisor do
    use DynamicSupervisor

    def start_link(_) do
        DynamicSupervisor.start_link(__MODULE__, :no_args, name: {:global, :workersupervisor})
    end

    def init(:no_args) do
        IO.puts("#{inspect self()}   1 spwaned here")
        DynamicSupervisor.init(strategy: :one_for_one)
    end

    def add_worker(number) do
        specs={Project.VampireWorkers, number }
        {:ok, _pid} = DynamicSupervisor.start_child({:global, :workersupervisor}, specs)
        Project.WorkerSupervisor2.add_worker(number)
    end

    def stopWorkerSupervisor() do
        {:stop, :normal, []}
    end

end
