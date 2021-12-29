module Day22

export part1, part2

using Base.Iterators
using OffsetArrays

struct Instruction
    power_on::Bool
    x::UnitRange{Int}
    y::UnitRange{Int}
    z::UnitRange{Int}
end

function read_instructions(input) 
    map(split.(input, " ")) do ins
        coords = split.(getindex.(split.(split(ins[2], ","), "="), 2), "..")
        ranges = [
            UnitRange(minimum(c), maximum(c)) 
            for c in [parse.(Int, coord) for coord in coords]
        ]
        Instruction(ins[1] == "on", ranges...)
    end
end

function is_init(ins::Instruction, area::UnitRange = -50:50)
    !isdisjoint(ins.x, area) &
    !isdisjoint(ins.y, area) &
    !isdisjoint(ins.z, area)
end

Base.CartesianIndices(i::Instruction) = CartesianIndices((i.x, i.y, i.z))
Base.minimum(i::Instruction) = min(minimum(i.x), minimum(i.y), minimum(i.z))
Base.maximum(i::Instruction) = max(maximum(i.x), maximum(i.y), maximum(i.z))
Base.minimum(x::Vector{Instruction}) = minimum(minimum.(x))
Base.maximum(x::Vector{Instruction}) = maximum(maximum.(x))

function reactor_core(range)
    dim = length(range)
    core = zeros(dim, dim, dim)
    OffsetArray(core, range, range, range)
end

function execute!(core, ins::Instruction)
    core[CartesianIndices(ins)] .= ins.power_on ? 1 : 0
end

function part1()
    inst = filter(is_init, read_instructions(readlines("data/day22.txt")))
    core = reactor_core(-50:50)
    for ins in inst 
        execute!(core, ins) 
    end
    sum(core)
end

function count_on(inst::Vector{Instruction})

    cubes = CartesianIndices[]
    itxns = Tuple{CartesianIndices, Int}[]
    numon = 0

    for i in eachindex(inst)
        ins = inst[i]
        indices = CartesianIndices(ins)
        newitxns = Tuple{CartesianIndices, Int}[]
        for cube in cubes
            # Remove pairwise intersections
            int = intersect(indices, cube)
            if length(int) > 0
                push!(newints, (int, 2))
                numon -= length(int)
            end
        end
        for (cube, n) in inter
            int = intersect(indices, cube)
            if length(int) > 0
                gen = n + 1
                isodd(gen) ?
                    (numon += length(int)) :
                    (numon -= length(int))
                push!(newints, (int, gen))
            end
        end
        if ins.power_on
            numon += length(indices)
            push!(cubes, indices)
        end
        append!(inter, newints)
    end

    return numon
end

function count_on(inst::Vector{Instruction})

    fcube = CartesianIndices(inst[begin])
    cubes = Tuple{CartesianIndices, Int}[(fcube, 1)]
    numon = length(fcube)

    for i in eachindex(inst)[2:end]
        curr_ins = inst[i]
        new_cube = CartesianIndices(curr_ins)
        new_itxn = Tuple{CartesianIndices, Int}[]
        for (cube, n) in cubes
            
            itxn = intersect(new_cube, cube)
            if length(itxn) > 0
                gen = n + 1
                # According to inclusion-exclusion principle:
                # pairwise intersections are excluded 
                # three-way intersections are included 
                # and so on...
                isodd(gen) ?
                    (numon += length(itxn)) :
                    (numon -= length(itxn))
                push!(new_itxn, (itxn, gen))
            end
        end
        if curr_ins.power_on
            # If instruction is power off, the number of powered on switches 
            # is increased but the intersection logic remains the same
            numon += length(new_cube)
            push!(cubes, (new_cube, 1))
        end
        append!(cubes, new_itxn)
    end
    return numon
end

part2() = count_on(read_instructions(readlines("data/day22.txt")))

end 