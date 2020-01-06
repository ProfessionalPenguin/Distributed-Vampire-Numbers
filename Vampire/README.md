# Vampire Numbers

The goal of this first project is to use Elixir and the actor model to build a good solution to this problem that runs well on multi-core machines.

## Developers

* **Rahul Singh Bhatia** - *UFID: ########*


### Prerequisites
#### Erlang

Erlang >= 19.0, available at <https://www.erlang.org/downloads>.

#### Elixir

To install elixir on a Mac, `brew install elixir`

Or else: [Elixir Installation Instruction](http://elixir-lang.org/install.html).

### Instructions

#### Run the project

    Change Directory and enter the "Vampire" folder
    cd ..\Vampire
    
    $ time ARG1=10000000 ARG2=20000000 mix run --no-halt
    where ARG1 and ARG2(global variables) represent the start and end range

## Running Time

The running time for the following inputs were:

    
    $ time ARG1=100000 ARG2=200000 mix run --no-halt
```elixir
    real    0m0.833s
    user    0m3.001s
    sys     0m0.121s
    CPU ratio : 3.75
    workers created : 200
```
    $ time ARG1=10000000 ARG2=20000000 mix run --no-halt
```elixir
    real    2m30.518s
    user    19m21.755s
    sys     0m4.228s
    CPU ratio : 7.8
    workers created : 20000
```
    $ time ARG1=10000000 ARG2=100000000 mix run --no-halt 

    (largest problem we solved)
```elixir
    real    16m37.841s
    user    129m46.699s
    sys     0m24.005s
    CPU ratio: 7.8
    workers created : 180000
```
### Actor Model

    The number of worker actors depends on the range of inputs given. The entire range is split into small subproblems for each worker to solve.

    Taking advantage of Elixir's extremely lightweight processes we decided to give
    each Worker Process a range of 500 numbers to scan. We can spawn hundreds to thousands of processes all running concurrently to solve the large problem. The reason we chose a small range of 500 numbers per Worker is so that if any failure occurs the same process can restart and recalculate the small range easily without losing any of the other results since each process is completely independant of each other.

    The flow of the program can be seen in more detail in the Project Stats.pdf

