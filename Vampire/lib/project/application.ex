defmodule Project.Proj1 do
    use Application

    def start(_type, _args) do
      from=String.to_integer(System.get_env("ARG1"))
      to=String.to_integer(System.get_env("ARG2"))

      check_ranges(from, to)

      from=if from==1 do 1500 else from end
      to=if to<2000 do 2000 else to end

      from= if from >= 10000 && from < 100000 do 100000 else from end
      from= if from >= 1000000 && from < 10000000 do 10000000 else from end

      to = if to > 10000 && to < 100000 do 10000 else to end
      to = if to > 1000000 && to < 10000000 do 1000000 else to end

      check_ranges(from,to)

      from=div(from,500)
      to=div(to,500)+1

      workers=to-from

      children = [
        Project.WorkerSupervisor,
        Project.Results,
        {Project.Vampire, {from, to, workers}}
      ]

      opts = [strategy: :one_for_all, name: Project.Supervisor]
      Supervisor.start_link(children, opts)
    end

    def check_ranges(from ,to) do
      if from==to or from>=to do
        IO.puts ("\nInvalid ranges. Please try again.\nVampire Numbers found : 0 ")
        System.halt(1)
      end

      if to-from<500 do
        IO.puts ("\nPlease enter a range larger than 500.")
        System.halt(1)
      end
    end
end
