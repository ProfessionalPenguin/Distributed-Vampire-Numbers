    defmodule Project.VampireWorkers do
    use GenServer, restart: :transient

    def start_link(number) do
        GenServer.start_link(__MODULE__, number , name: String.to_atom("#{number}"))
    end

    def init(number) do
        GenServer.cast(String.to_atom("#{number}"), :startVamp)
        { :ok, number }
    end

    def handle_cast(:startVamp, number) do
        loop(number)
    end

    def factors(n) do
        range1 = trunc(n / :math.pow(10, div(length(to_charlist(n)) , 2)))
        range2 = :math.sqrt(n) |> round
        for x <- range1..range2, rem(n, x) == 0 do {x, div(n, x)} end
    end

    def vfactors(n) do
        cond do
        div(length(to_charlist(n)), 2) == 0 -> []
        true ->
                #half length of number
                half = div(length(to_charlist(n)), 2)
                sortedchars = Enum.sort(String.codepoints("#{n}")) #0126
                Enum.filter(factors(n),fn {first, second} ->
                    length(to_charlist(first)) == half && length(to_charlist(second)) == half &&
                    Enum.count([first, second], fn x -> rem(x, 10) == 0 end) != 2 &&
                    Enum.sort(String.codepoints("#{first}#{second}")) == sortedchars
                    end)#21 60 -> 0126
            end
    end #vfactors end

    def loop(range) do
        (range-499)..range |> Enum.each( fn (number) ->
        case vfactors(number) do
            [] -> 0
            vf -> Project.Results.add_result([number | Enum.flat_map(vf, fn{x, y} -> [x,y] end)])
        end
        end)
        Project.Vampire.isDone()
        {:stop, :normal, nil}
    end

end

