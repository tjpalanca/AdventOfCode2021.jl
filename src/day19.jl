module Day19 

using Combinatorics

export part1, part2

struct Scanner{N}
    id::Int
    positions::Vector{CartesianIndex{N}}
end

function read_scanners(file::String)
    txt = readlines(file)
    sep = vcat(0, findall(txt .== "")) 
    idx = [sep[i:i+1] for i in 1:(length(sep) - 1)]
    map(txt[(i[1] + 1):(i[2] - 1)] for i in idx) do txt
        Scanner(
            parse(Int, replace(txt[1], " " => "", "scanner" => "", "-" => "")),
            [CartesianIndex(parse.(Int, i)...) for i in split.(txt[2:end], ",")]
        )
    end
end

function match(s1::Scanner, s2::Scanner, threshold::Int)
    candidates = collect(Iterators.product(s1.positions, s2.positions))
    implied    = [c[1] - c[2] for c in candidates]
    agreements = filter(p -> last(p) >= threshold, pairs(Dict(
        pot => max(
            sum(pot in implied[:, i] for i in 1:(size(candidates)[2])),
            sum(pot in implied[i, :] for i in 1:(size(candidates)[1]))
        )
        for pot in unique(implied)
    )))
    if length(agreements) > 0
        return collect(keys(agreements))[1]
    end
end

function rotations(positions::Vector{CartesianIndex{N}}) where N 
    flips = map(collect(powerset(1:N))) do set
        flip = repeat([1], N)
        flip[set] .= -1 
        flip
    end
    rotates = permutations(1:N, N)
    flipped = 
        [[CartesianIndex((Tuple(p) .* f)...) for p in positions] for f in flips]
    [CartesianIndex.(c[r] for c in Tuple.(f)) for r in rotates for f in flipped]
end

rotations(s::Scanner) = [Scanner(s.id, rot) for rot in rotations(s.positions)]

function align(s1::Scanner, s2::Scanner, threshold::Int) 
    s2r = rotations(s2)
    mat = [match(s1, s, threshold) for s in s2r]
    fnd = findall(.!isnothing.(mat))
    if length(fnd) > 0
        return only(s2r[fnd]), only(mat[fnd])
    end
end

function translate(scanner::Scanner, offset::CartesianIndex) 
    Scanner(
        scanner.id,
        [p + offset for p in scanner.positions]
    )
end

function match(scanners::Vector{Scanner{N}}) where N
    matched = Tuple{Scanner{N}, CartesianIndex{N}}[]
    push!(matched, (scanners[1], CartesianIndex([0 for i in 1:N]...)))
    unmatched = scanners[2:end]
    while length(unmatched) > 0
        matches = filter(
            p -> !isnothing(p[2]), 
            [m => align(m[1], u, 12) for m in matched, u in unmatched]
        )
        for mat in matches
            add = findall(p -> p[1].id == mat[2][1].id, matched)
            (length(add) == 0) && 
                push!(matched, (mat[2][1], mat[2][2] + mat[1][2]))
            rmv = findall(p -> p.id == mat[2][1].id, unmatched)
            (length(rmv) > 0) && popat!(unmatched, rmv...)
        end
    end
    return matched
end

function align(scanners::Vector{Scanner{N}}) where N
    matched = match(scanners)
    return [translate(m...) for m in matched]
end

manhattan(x, y) =  sum(abs.(Tuple(x - y)))

function part1() 
    scanners = read_scanners("data/day19.txt")
    aligned = align(scanners)
    length(unique(reduce(vcat, getproperty.(aligned, :positions))))
end

function part2()
    scanners = read_scanners("data/day19.txt")
    matched = match(scanners)
    scanner_positions = getindex.(matched, 2)
    scanner_pairs = collect(combinations(scanner_positions, 2))
    maximum(manhattan(pair...) for pair in scanner_pairs)
end

end