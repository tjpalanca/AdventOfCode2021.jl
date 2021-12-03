module Day3

using StatsBase

binaries = split.(readlines("data/day3.txt"), "")

most_common(x) = map(i -> mode(map(x_i -> x_i[i], x)), 1:length(x[1])) 
least_common(x) = map(x_i -> x_i == "0" ? "1" : "0", most_common(x))

gamma = parse(Int, string(most_common(binaries)...), base = 2)
epsilon = parse(Int, string(least_common(binaries)...), base = 2)
power_consumption = gamma * epsilon

function filter_step(b, i)
    if (length(b) == 1) 
        return b 
    else 
        mc = modes(map(x -> x[i], b))
        mc = length(mc) > 1 ? "1" : mc[1,1]
        return filter(x -> x[i] == mc, b)
    end
end

oxygen_generator = 
    reduce(filter_step, 1:length(binaries[1]); init = binaries)[1] |>
    surviving -> string(surviving...) |>
    surviving -> parse(Int, surviving; base = 2)

function filter_step_negative(b, i) 
    if (length(b) == 1) 
        return b
    else 
        mc = modes(map(x -> x[i], b))
        mc = length(mc) > 1 ? "0" : ( mc[1,1] == "1" ? "0" : "1" )
        return filter(x -> x[i] == mc, b)
    end
end 

co2_scrubber = 
    reduce(filter_step_negative, 1:length(binaries[1]); init = binaries)[1] |>
    surviving -> string(surviving...) |>
    surviving -> parse(Int, surviving; base = 2)

life_support = co2_scrubber * oxygen_generator

end