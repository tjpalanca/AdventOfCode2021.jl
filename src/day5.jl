module Day5

export part1, part2

function input()
    map(readlines("data/day5.txt")) do line 
        p1, p2 = split(line, " -> ")
        x1, y1 = parse.(Int, split(p1, ","))
        x2, y2 = parse.(Int, split(p2, ",")) 
        return ((x1, y1), (x2, y2))
    end
end

function hvlines()
    hvlines = filter(input()) do line
        x1, y1 = line[1]
        x2, y2 = line[2]
        return (x1 == x2) | (y1 == y2)
    end
end

function points(line)
    x1, y1 = line[1]
    x2, y2 = line[2]
    px = x1:(x1 < x2 ? 1 : -1):x2
    py = y1:(y1 < y2 ? 1 : -1):y2
    if (x1 == x2) 
        return [(x1, y) for y in py]
    elseif (y1 == y2)
        return [(x, y1) for x in px]
    else 
        return [(x, y) for (x, y) in zip(px, py)]
    end
end

function count_overlaps(lines) 

    floor = zeros(1000, 1000)

    for path in map(points, lines)
        for point in path
            floor[point...] += 1
        end
    end

    return length(filter(x -> x >= 2, floor))

end

function part1()
    count_overlaps(hvlines())
end

function part2() 
    count_overlaps(input())
end

end