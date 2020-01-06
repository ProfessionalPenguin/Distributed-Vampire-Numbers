defmodule Project.Vampire do
    use GenServer

    def start_link({from, to, workers}) do
        GenServer.start_link(__MODULE__, {from, to, workers}, name: {:global, :vampire_server})
    end

    def init({from, to, workers}) do
       # Process.send_after(self(), :start, 0)
        IO.puts("#{inspect self()}")
        from=div(from,20000)
        to=div(to,20000)
        workers=(to-from)*2
        { :ok, {from, to, workers} }
    end


    def isDone() do
        GenServer.cast({:global, :vampire_server}, :done)
    end

    def startVamp() do
        GenServer.cast({:global, :vampire_server}, :start)
    end

    def handle_cast(:start, {from, to, workers}) do

       from..to |> Enum.map(fn (x) -> x*20000 end) |> Enum.each( fn (number) ->
        Project.WorkerSupervisor.add_worker(number) end)
        {:noreply, {from, to, workers}}
    end

    def handle_cast(:done , {_from, _to, _workers=1}) do
        Project.Results.publish_results()
        Project.WorkerSupervisor.stopWorkerSupervisor()
        Project.WorkerSupervisor2.stopWorkerSupervisor()
        {:stop, :normal, []}
    end

    def handle_cast(:done, {from, to, workers}) do
        {:noreply, {from, to, workers-1}}
    end

end
