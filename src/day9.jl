module Day9 

export part1, part2

heightmap() = transpose(parse.(Int, hcat(split.(readlines("data/day9.txt"), "")...)))

is_valid((i, j)) = (i > 0) && (i <= 100) && (j > 0) && (j <= 100)

adjacents((i, j)) = filter(is_valid, [(i + 1, j), (i - 1, j), (i, j + 1), (i, j - 1)])

is_lowpoint(i, j, hm) = all([hm[i, j] for (i, j) in adjacents((i, j))] .> hm[i, j])

find_lowpoints(hm) = findall([is_lowpoint(i, j, hm) for i in 1:size(hm)[1], j in 1:size(hm)[2]])

function part1() 

    hm = heightmap()
    lowpoint_heights = hm[find_lowpoints(hm)]
    risk_scores = lowpoint_heights .+ 1
    return sum(risk_scores)

end

function fill_basin(start, border) 
    point = [start]
    basin = []
    while (length(point) > 0) 
        push!(basin, point...)
        point = reduce(vcat, setdiff.(adjacents.(point), Ref(basin), Ref(border)))
    end
    return unique(basin)
end

function part2() 
    hm = heightmap()
    lp = Tuple.(find_lowpoints(hm))
    border = Tuple.(findall(hm .== 9))
    basins = fill_basin.(lp, Ref(border))
    top_3_basin_sizes = sort(map(length, basins), rev = true)[1:3]
    return reduce(*, top_3_basin_sizes)
end

end