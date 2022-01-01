module Day25

export part1, part2

parse_seafloor(txt) = permutedims(reduce(hcat, [[c for c in i] for i in txt])) 
occupied(mat) = findall(c -> c != '.', mat)

function step!(seafloor)
    floorsize = size(seafloor)
    nmoves = 0
    for direction in ('>', 'v')
        positions = occupied(seafloor)
        herd = positions[seafloor[positions] .== direction]
        for old in herd
            new = CartesianIndex(
                direction == '>' ? old[1] : mod1(old[1] + 1, floorsize[1]),
                direction == 'v' ? old[2] : mod1(old[2] + 1, floorsize[2])
            )
            if !(new in positions)
                nmoves += 1
                seafloor[old] = '.' 
                seafloor[new] = direction
            end
        end
    end
    return nmoves
end

function simulate!(seafloor)
    nsteps = 0
    while true 
        nmoves = step!(seafloor)
        nsteps += 1
        (nmoves == 0) && break 
    end
    return nsteps 
end

function part1() 
    seafloor = parse_seafloor(readlines("data/day25.txt"))
    convergence = simulate!(seafloor)
    return seafloor, convergence 
end

function part2()
    println("No part 2 in this day") 
end

end