module Day17

export part1, part2

const input = readline("data/day17.txt")

struct TargetArea 
    x::Int64 
    xend::Int64
    y::Int64
    yend::Int64
end

function target_area() 
    getindex.(split.(split(split(input, ": ")[2], ", "), "="), 2) |>
        i -> parse.(Int, reduce(hcat, split.(i, ".."))) |>
        m -> TargetArea(m[1, 1], m[2, 1], m[1, 2], m[2, 2])
end

struct Probe 
    x::Int64
    y::Int64 
    velx::Int64 
    vely::Int64
end

Probe(velx::Int64, vely::Int64) = Probe(0, 0, velx, vely)
within(p::Probe, a::TargetArea) = (p.x in a.x:a.xend) & (p.y in a.y:a.yend)
below(p::Probe, a::TargetArea) = p.y <= min(a.y, a.yend)

move(p::Probe) = Probe(
    p.x + p.velx,
    p.y + p.vely,
    if p.velx > 0 
        p.velx - 1 
    elseif p.velx < 0 
        p.velx + 1 
    else 
        0
    end,
    p.vely - 1
)

function simulate(probe::Probe, area::TargetArea)
    path = Probe[]
    while !within(probe, area) & !below(probe, area)
        probe = move(probe)
        push!(path, probe)
    end
    return path, within(probe, area)     
end

max_y(path::Vector{Probe}) = maximum(p -> p.y, path)

function velspace(a::TargetArea)
    xbound = maximum(abs.([a.xend, a.x]))
    ybound = maximum(abs.([a.yend, a.y]))
    [(x, y) for x in -xbound:xbound, y in -ybound:ybound]
end

function part1()
    ta = target_area()
    vs = velspace(ta)
    vy = 0
    for v in vs
        p = Probe(v...)
        path, valid = simulate(p, ta)
        vy = valid ? max(max_y(path), vy) : vy
    end
    return vy
end 

function part2()
    ta = target_area()
    vs = velspace(ta)
    vp = 0 
    for v in vs 
        p = Probe(v...)
        path, valid = simulate(p, ta)
        if valid vp += 1 end
    end
    return vp
end

end