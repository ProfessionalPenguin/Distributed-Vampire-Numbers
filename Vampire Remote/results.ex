defmodule Project.Results do
    use GenServer

    def start_link(_) do
        GenServer.start_link(__MODULE__, :no_args, name: {:global, :results_server})
    end

    def add_result(number) do
        GenServer.cast({:global, :results_server}, {:valid, number})
    end

    def publish_results() do
        GenServer.cast({:global, :results_server}, :publish)
    end

    # server stuff
    def init(:no_args) do
        {:ok, []}
    end

    def handle_cast({:valid , number}, results) do
        results=[number | results]
        Enum.each(number, fn x -> IO.write(x); IO.write(" ") end)
        IO.write("\n")
        {:noreply, results}
    end

    def handle_cast(:publish , state) do
        len=length(state)
        message="Number of Vampire numbers found : "
        IO.puts("#{message}#{len}")
        #IO.puts(inspect state)
        {:stop, :normal, []}
        #System.halt(1)
    end
end

