defmodule Project.Vampire do
    use GenServer

    def start_link({from, to, workers}) do
        GenServer.start_link(__MODULE__, {from, to, workers}, name: __MODULE__)
    end

    def init({from, to, workers}) do
        Process.send_after(self(), :start, 0)
        { :ok, {from, to, workers} }
    end

    def isDone() do
        GenServer.cast(__MODULE__, :done)
    end

    def handle_info(:start, {from, to, workers}) do
        from..to |> Enum.map(fn (x) -> x*500 end) |> Enum.each( fn (number) -> Project.WorkerSupervisor.add_worker(number) end)
        #100..200 |> Enum.map(fn (x) -> x*1000 end) |> Enum.each( fn (number) -> Project.WorkerSupervisor.add_worker(number) end)
        {:noreply, {from, to, workers}}
    end

    def handle_cast(:done , {_from, _to, _workers=1}) do
        Project.Results.publish_results()
    end

    def handle_cast(:done, {from, to, workers}) do
        {:noreply, {from, to, workers-1}}
    end

end
