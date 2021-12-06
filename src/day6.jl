module Day6

using StatsBase

export part1, part2

function input() 
    parse.(Int, split(readline("data/day6.txt"), ",")) |>
        StatsBase.countmap
end

function move_one_day(timers) 

    newtimers = Dict()
    for (day, fish) in pairs(timers)
        if day >= 1 
            newtimers[day - 1] = get(newtimers, day - 1, 0) + fish
        else 
            newtimers[6] = get(newtimers, 6, 0) + fish 
            newtimers[8] = get(newtimers, 8, 0) + fish
        end
    end
    return newtimers

end

function move_n_days(timers, n) 

    for day in 1:n 
        println("Day $(day)")
        timers = move_one_day(timers)
    end
    return timers

end

function total_fish(timers) 
    sum(values(timers))
end

part1() = total_fish(move_n_days(input(), 80))
part2() = total_fish(move_n_days(input(), 256))

end