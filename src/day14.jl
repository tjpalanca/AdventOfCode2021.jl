module Day14

using StatsBase: countmap

const input = readlines("data/day14.txt")
template_count() = countmap([input[1][i:(i + 1)] for i in 1:(length(input[1]) - 1)])
template_tally() = countmap(input[1])
rules() = Dict(pair[1] => pair[2][1] for pair in split.(input[3:end], " -> "))

range_size(x) = maximum(x) - minimum(x)

function expand_polymer!(polymer, tallies, ruleset)
    expansion = Dict()
    for pair in intersect(keys(polymer), keys(ruleset))
        new_letter   = ruleset[pair] 
        new_pairs    = [pair[1] * new_letter, new_letter * pair[2]]
        num_new_pair = pop!(polymer, pair)
        mergewith!(+, tallies, Dict(new_letter => num_new_pair))
        mergewith!(+, expansion, Dict(new_pair => num_new_pair for new_pair in new_pairs))
    end
    mergewith!(+, polymer, expansion)
end

function calculate_range_after_expansion(N) 
    polymer = template_count()
    tallies = template_tally()
    ruleset = rules()
    for _ in 1:N
        expand_polymer!(polymer, tallies, ruleset)
    end
    return tallies |> values |> range_size
end

part1() = calculate_range_after_expansion(10)
part2() = calculate_range_after_expansion(40)

end