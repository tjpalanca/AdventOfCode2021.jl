module Day11

export part1, part2

init() = collect(transpose(parse.(Int, reduce(hcat, split.(readlines("data/day11.txt"), "")))))

is_valid(p) = (p[1] > 0) & (p[1] <= 10) & (p[2] > 0) & (p[2] <= 10)

adjacents(p) = filter(is_valid, [
p .+ CartesianIndices((1:1, -1:1))...,
p .- CartesianIndices((1:1, -1:1))...,
p + CartesianIndex(0, 1),
p - CartesianIndex(0, 1)
])

function advance_step(state) 
    state .+= 1
    toflash = findall(state .> 9)
    flashed = CartesianIndex{2}[]
    while length(toflash) > 0 
        for affected in adjacents.(toflash)
            state[affected] .+= 1
        end
        push!(flashed, toflash...)
        toflash = setdiff(findall(state .> 9), flashed)
    end
    state[flashed] .= 0
    return state, flashed
end

function part1(n_steps = 100)
    state = init()
    flash = 0
    for i in 1:n_steps
        state, flashed = advance_step(state)
        flash += length(flashed)
    end
    return flash
end

function part2()
    state = init()
    all_flash_step = nothing
    step = 0
    while isnothing(all_flash_step)
        state, flashed = advance_step(state)
        step += 1
        if length(flashed) == 100
            all_flash_step = step
        end
    end
    all_flash_step
end

end