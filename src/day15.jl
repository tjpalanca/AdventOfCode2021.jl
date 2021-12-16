module Day15

using ProgressLogging
export part1, part2

risk_map() = permutedims(parse.(Int, reduce(hcat, split.(readlines("data/day15.txt"), ""))))
start_pt() = CartesianIndex(1, 1)
end_pt(risk_map) = CartesianIndex(size(risk_map))
adjacent(p, dims) = filter(
    i -> all(Tuple(i) .> (0, 0)) & all(Tuple(i) .<= dims),
    [p + i for i in vcat(CartesianIndex.([-1, 1], 0), CartesianIndex.(0, [-1, 1]))]
)

function safest_path(risk_map, start_pt, end_pt)

    map_size = size(risk_map)
    map_elem = map_size[1] * map_size[2]
    distances = fill(Inf, map_size) 
    distances[start_pt] = 0
    tovisit = reduce(vcat, collect(CartesianIndices(risk_map)))
    
    @withprogress while length(tovisit) > 0
        @logprogress 1 - (length(tovisit) / map_elem)
        current = popat!(tovisit, argmin(distances[tovisit]))
        for adj in adjacent(current, map_size)
            distances[adj] = min(
                distances[current] + risk_map[adj],
                distances[adj]
            )
        end
    end
    
    distances[end_pt]

end

function part1() 
    rm = risk_map()
    s, e = start_pt(), end_pt(rm)
    safest_path(rm, s, e)
end

function expand_map(risk_map)
    full_map = Matrix{Matrix{Int64}}(undef, 5, 5)
    for tile_loc in CartesianIndices((5, 5)) 
        full_map[tile_loc] = map(
            x -> x > 9 ? mod(x, 9) : x,
            (tile_loc[1] + tile_loc[2] - 2) .+ risk_map
        ) 
    end
    return reduce(
        vcat, 
        reduce(hcat, full_map[i, :]) 
        for i in 1:size(full_map)[2]
    )
end

function part2() 
    rm = expand_map(risk_map())
    s, e = start_pt(), end_pt(rm)
    safest_path(rm, s, e)
end

end

