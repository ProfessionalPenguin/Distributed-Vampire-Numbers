defmodule Project.ResultsTest do
    use ExUnit.Case
    alias Project.Results

    test "add entries to results" do
        Results.add_result(123)
        Results.add_result(123)
        Results.add_result(123)
        Results.add_result(123)
        Results.add_result(123)
        Results.add_result(123)
        Results.add_result(123)

    end
end