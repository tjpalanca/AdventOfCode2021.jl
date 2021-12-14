module Day13

export part1, part2

using SparseArrays

input() = readlines("data/day13.txt")
dots()  = [
    CartesianIndex((parse.(Int, coord))...) 
    for coord in split.(input()[1:732], ",")
]
folds() = [[fold[1], parse(Int, fold[2])] for fold in split.(input()[734:end], "=")]

function fold_up(dots, y)
    upper_side = filter(d -> d[2] < y, dots) 
    lower_side = filter(d -> d[2] > y, dots)
    flipped_lower_side = [CartesianIndex(dot[1], y - (dot[2] - y)) for dot in lower_side]
    return unique(vcat(upper_side, flipped_lower_side))
end
function fold_left(dots, x)
    left_side  = filter(d -> d[1] < x, dots)
    right_side = filter(d -> d[1] > x, dots) 
    flipped_right_side = [CartesianIndex(x - (dot[1] - x), dot[2]) for dot in right_side]
    return unique(vcat(left_side, flipped_right_side))  
end
function fold(dots, fold)
    if fold[1] == "fold along x"
        fold_left(dots, fold[2])
    elseif fold[1] == "fold along y"
        fold_up(dots, fold[2])
    else 
        error("Unrecognized fold")
    end
end

part1() = length(fold(dots(), folds()[1]))

function part2() 
    state = dots()
    for f in folds()
        state = fold(state, f)
    end 
    final = [coord + CartesianIndex(1, 1) for coord in state]
    code = sparse(last.(Tuple.(final)), first.(Tuple.(final)), 1)
    display(code)
end

end