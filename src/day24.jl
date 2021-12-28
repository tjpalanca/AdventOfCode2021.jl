module Day24

export part1, part2

is_int(x) = tryparse(Int, x) !== nothing
as_int(x) = parse(Int, x)

function create_program(instructions)
    inst = split.(instructions, " ")
    input_names = unique(getindex.(inst, 2))
    function program(inputs, inits...)
        names = copy(input_names)
        store = Dict{AbstractString, Int}(n => 0 for n in names)
        for init in inits
            store[init[1]] = init[2]
        end
        for ins in inst
            if ins[1] == "inp"
                store[ins[2]] = popfirst!(inputs)
            else
                operand = is_int(ins[3]) ? as_int(ins[3]) : store[ins[3]]
                if ins[1] == "add"
                    store[ins[2]] += operand
                elseif ins[1] == "mul"
                    store[ins[2]] *= operand
                elseif ins[1] == "div"
                    store[ins[2]] ÷= operand
                elseif ins[1] == "mod"
                    store[ins[2]] = mod(store[ins[2]], operand)
                elseif ins[1] == "eql"
                    store[ins[2]] = store[ins[2]] == operand ? 1 : 0
                end
            end
        end
        return store
    end
end

function monad_program()
    monad = create_program(readlines("data/day24.txt"))
    function monad_program(number)
        monad(parse.(Int, [num for num in number]))["z"] == 0
    end
end

function program_segments() 
    input = readlines("data/day24.txt")
    segments = [input[(i+1):(i+18)] for i in 0:18:(length(input) - 1)]
    create_program.(segments)
end

function calculate_states(type, prune)
    segments = program_segments()
    results = Dict{Int, Vector{Int}}(0 => Int[])
    for segment in segments
        previous = results
        results = Dict{Int, Vector{Int}}()
        for i in 1:9, r in pairs(previous)
            state = segment([i], "z" => r[1])["z"]
            if abs(state) < prune
                if haskey(results, state)
                    if (type == "max") && (i < results[state][end])
                        results[state] = vcat(r[2], i)
                    end
                    if (type == "min") && (i > results[state][end])
                        results[state] = vcat(r[2], i)
                    end
                else
                    results[state] = vcat(r[2], i)
                end
            end
        end
        @show length(results)
    end
    return results
end 

function part1()
    states = calculate_states("max", 10000000)
    number = string(a[0]...)
    @assert monad_program()(number) == true
    return number
end

function part2()
    states = calculate_states("min", 10000000)
    number = string(a[0]...)
    @assert monad_program()(number) == true
    return number
end

end