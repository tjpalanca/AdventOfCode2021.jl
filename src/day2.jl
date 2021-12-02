module Day2

directions = split.(readlines("data/day2.txt"), " ")

position = 0
depth = 0

for direction in directions 
    if direction[1] == "up"
        depth -= parse(Int, direction[2])
    elseif direction[1] == "down"
        depth += parse(Int, direction[2])
    elseif direction[1] == "forward"
        position += parse(Int, direction[2])
    else
        error("Invalid direction")
    end
end

part1_ans = position * depth

aim = 0
position = 0
depth = 0

for direction in directions 
    if direction[1] == "up"
        aim -= parse(Int, direction[2])
    elseif direction[1] == "down"
        aim += parse(Int, direction[2])
    elseif direction[1] == "forward"
        position += parse(Int, direction[2])
        depth += parse(Int, direction[2]) * aim
    else
        error("Invalid direction")
    end
end

part2_ans = position * depth

end