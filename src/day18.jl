module Day18 

using Combinatorics

export part1, part2

mutable struct SnailfishNumber
    l::Union{SnailfishNumber, Int}
    r::Union{SnailfishNumber, Int}
end

function Base.parse(::Type{SnailfishNumber}, str::AbstractString) 
    eval(Meta.parse(replace(str, "[" => "SnailfishNumber(", "]" => ")")))
end

Base.getindex(n::SnailfishNumber, i::Vector{Symbol}) = 
    length(i) == 0 ? n : reduce(getproperty, i; init = n)

Base.setindex!(n::SnailfishNumber, v, i::Vector{Symbol}) = 
    length(i) == 1 ?
    setproperty!(n, popfirst!(i), v) : 
    setindex!(getproperty(n, popfirst!(i)), v, i)

text(n::SnailfishNumber) = "[$(text(n.l)),$(text(n.r))]"
text(n::Int) = string(n)
Base.show(io::IO, x::SnailfishNumber) = println(io, text(x))

is_leaf(root, path) = all(root[vcat(path, d)] isa Int for d in (:l, :r))
is_explodable(root, path) = is_leaf(root, path) & (length(path) >= 4)

function find_exploder(root::SnailfishNumber, path::Vector{Symbol} = Symbol[])
    if root[path] isa SnailfishNumber
        if is_explodable(root, path)
            return path
        else 
            exploder = find_exploder(root, vcat(path, :l))
            isnothing(exploder) && 
                (exploder = find_exploder(root, vcat(path, :r)))
            return exploder
        end 
    end
end

function find_neighbor(root::SnailfishNumber, path::Vector{Symbol}, dir::Symbol)
    @assert dir in (:r, :l)
    opp = dir == :r ? :l : :r
    if opp in path
        branch = path[1:findlast(==(opp), path)]
        branch[end] = dir
        while (root[branch] isa SnailfishNumber) push!(branch, opp) end
        branch
    end
end

function explode!(root::SnailfishNumber)
    exploder = find_exploder(root)
    if !isnothing(exploder)
        rn = find_neighbor(root, exploder, :r)
        ln = find_neighbor(root, exploder, :l)
        !isnothing(ln) && (root[ln] += root[exploder].l)
        !isnothing(rn) && (root[rn] += root[exploder].r)
        root[exploder] = 0 
        return true
    else 
        return false
    end
end

function find_splitter(root::SnailfishNumber, path::Vector{Symbol} = Symbol[])
    if root[path] isa Int && root[path] >= 10 
        return path
    elseif root[path] isa SnailfishNumber
        splitter = find_splitter(root, vcat(path, :l))
        isnothing(splitter) && 
            (splitter = find_splitter(root, vcat(path, :r)))
        return splitter
    end 
end

function split!(root::SnailfishNumber)
    splitter = find_splitter(root)
    if !isnothing(splitter)
        root[splitter] = SnailfishNumber(
            Int(round(root[splitter] / 2, RoundDown)),
            Int(round(root[splitter] / 2, RoundUp))
        )  
        return true
    else 
        return false
    end
end

function reduce!(n::SnailfishNumber)
    while true 
        explode!(n) && continue 
        split!(n) && continue 
        break 
    end
end

function (Base.:+)(x::SnailfishNumber, y::SnailfishNumber) 
    n = SnailfishNumber(deepcopy(x), deepcopy(y))
    reduce!(n)
    return n 
end

magnitude(n::SnailfishNumber) = (3 * magnitude(n.l)) + (2 * magnitude(n.r))
magnitude(n::Int) = n

function test() 
    S1 = parse.(SnailfishNumber, readlines("data/day18_sample1.txt"))
    A1 = reduce(+, S1)
    @assert text(A1) == 
        "[[[[8,7],[7,7]],[[8,6],[7,7]]],[[[0,7],[6,6]],[8,7]]]"
    S2 = parse.(SnailfishNumber, readlines("data/day18_sample2.txt"))
    A2 = reduce(+, S2)
    @assert text(A2) == 
        "[[[[6,6],[7,6]],[[7,7],[7,0]]],[[[7,7],[7,7]],[[7,8],[9,9]]]]"
    @assert magnitude(A2) == 4140
end

function part1()
    numbers = parse.(SnailfishNumber, readlines("data/day18.txt"))
    sum = reduce(+, numbers)
    magnitude(sum)
end

function part2()
    numbers = parse.(SnailfishNumber, readlines("data/day18.txt"))
    numpair = collect(permutations(numbers, 2))
    maximum(magnitude.(reduce.(+, numpair)))
end

end