module Day10

export part1, part2

lines() = readlines("data/day10.txt")

closer = Dict(
    '(' => ')',
    '[' => ']',
    '{' => '}',
    '<' => '>'
)

syntax_scores = Dict(
    ')' => 3,
    ']' => 57,
    '}' => 1197,
    '>' => 25137
)

autocomplete_scores = Dict(
    ')' => 1,
    ']' => 2,
    '}' => 3,
    '>' => 4
)

function corrupt_char(line) 
    stack = []
    for char in line 
        if char ∈ keys(closer)
            push!(stack, char)
        elseif char ∈ values(closer)
            opener = pop!(stack)
            if (closer[opener] != char)
                return char
            end
        end
    end
    return nothing
end

function part1() 
    ls = lines()
    corrupt_chars = filter(!isnothing, corrupt_char.(ls))
    return sum(syntax_scores[c] for c in corrupt_chars)
end

function autocomplete_chars(line)
    stack = []
    for char in line
        if char ∈ keys(closer)
            push!(stack, char)
        elseif char ∈ values(closer)
            pop!(stack)
        end
    end
    return [closer[c] for c in reverse(stack)]
end

function autocomplete_score(chars) 
    score = 0
    for char in chars 
        score *= 5
        score += autocomplete_scores[char]
    end
    return(score)
end

function part2() 
    ls = lines()
    non_corrupt_lines = ls[findall(map(isnothing, corrupt_char.(ls)))]
    scores = autocomplete_score.(autocomplete_chars.(non_corrupt_lines))
    return sort(scores)[Integer(length(scores)/2 + 0.5)]
end

end