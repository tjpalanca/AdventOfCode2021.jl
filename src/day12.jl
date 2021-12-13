module Day12

export part1, part2

using StatsBase: countmap

const paths = split.(readlines("data/day12.txt"), "-")
const nodes = unique(reduce(vcat, paths))

const adjacencies = Dict(
    node => only.(setdiff.(filter(p -> node in p, paths), Ref([node]))) 
    for node in nodes
)

adjacent(node) = adjacencies[node]
is_start_or_end(node) = node in ["start", "end"]
is_small(node) = (lowercase(node) == node) & !is_start_or_end(node)
is_large(node) = !is_small(node) & !is_start_or_end(node)
is_complete(path) = "end" ∈ path
branches(path) = [vcat(path, new) for new in adjacent(path[end])]


under_limit(path, n, pair = 0) = count(collect(values(countmap(path))) .> n) <= pair

function is_valid1(path)
    under_limit(filter(is_small, path), 1) & 
    under_limit(filter(is_start_or_end, path), 1)
end

function num_paths(is_valid)
    p = [["start"]]
    complete_paths = 0
    while length(p) > 0
        b = reduce(vcat, branches.(p))
        splice!(b, findall(.!is_valid.(b)))
        complete_paths += length(splice!(b, findall(is_complete.(b))))
        p = b
    end
    return complete_paths
end

function is_valid2(path)
    under_limit(filter(is_start_or_end, path), 1) & (
        under_limit(filter(is_small, path), 1) ||
        (
            under_limit(filter(is_small, path), 1, 1) &
            under_limit(filter(is_small, path), 2)
        )
    )
end

part1() = num_paths(is_valid1)
part2() = num_paths(is_valid2)

end