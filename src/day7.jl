module Day7

export part1, part2

get_positions() = parse.(Int, split(readline("data/day7.txt"), ','))
range(x) = minimum(x):maximum(x)
fuel_required(p, positions) = sum(abs.(p .- positions))
fuel_required2(p, positions) = sum([sum(1:d) for d in abs.(p .- positions)])

part1() = get_positions() |>
    positions -> fuel_required.(range(positions), Ref(positions)) |>
    minimum

part2() = get_positions() |>
    positions -> fuel_required2.(range(positions), Ref(positions)) |>
    minimum

end