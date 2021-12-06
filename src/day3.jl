module Day3

using StatsBase

export part1, part2

function input() 
    split.(readlines("data/day3.txt"), "")
end

function mode(x)
    d = countmap(x)
    v = collect(values(d))
    k = collect(keys(d))
    return k[findall(v .== maximum(v))]
end 

function antimode(x)
    d = countmap(x)
    v = collect(values(d))
    k = collect(keys(d))
    return k[findall(v .== minimum(v))]
end

most_common(x) = map(1:length(x[1])) do i 
    return mode(map(x_i -> x_i[i], x))[1]
end
least_common(x) = map(1:length(x[1])) do i 
    return antimode(map(x_i -> x_i[i], x))[1]
end

array_to_decimal(x) = parse(Int, string(x...), base = 2)

function filter_step(b, i)
    if (length(b) == 1) 
        return b 
    else 
        mc = mode(map(x -> x[i], b))
        mc = length(mc) > 1 ? "1" : mc[1]
        return filter(x -> x[i] == mc, b)
    end
end

function filter_step_negative(b, i) 
    if (length(b) == 1) 
        return b
    else 
        mc = antimode(map(x -> x[i], b))
        mc = length(mc) > 1 ? "0" : mc[1]
        return filter(x -> x[i] == mc, b)
    end
end 

function part1()
    binaries = input()
    gamma = array_to_decimal(most_common(binaries))
    epsilon = array_to_decimal(least_common(binaries))
    return gamma * epsilon
end

function part2()
    binaries = input()
    binlen = length(binaries[1])
    oxygen_generator = 
        reduce(filter_step, 1:binlen; init = binaries)[1] |>
        array_to_decimal        
    co2_scrubber = 
        reduce(filter_step_negative, 1:binlen; init = binaries)[1] |>
        array_to_decimal
    return co2_scrubber * oxygen_generator
end

end