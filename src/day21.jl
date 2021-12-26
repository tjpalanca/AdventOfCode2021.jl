module Day21

export part1, part2

using Combinatorics
using StatsBase
using Base.Iterators

const input = readlines("data/day21.txt")

mutable struct Player 
    position::Int 
    score::Int
end

move!(p::Player, n::Int) = p.position = mod1(p.position + n, 10)
score!(p::Player, n::Int) = p.score += n

mutable struct Dice
    current::Int
    times_rolled::Int
end

function roll!(d::Dice)
    roll_value = d.current
    d.times_rolled += 1
    d.current = mod1(d.current + 1, 100) 
    return roll_value
end

roll!(d::Dice, n::Int) = [roll!(d) for i in 1:n]

mutable struct Game
    players::Vector{Player}
    turn::Int
    dice::Dice
end

function turn!(g::Game)
    roll = sum(roll!(g.dice, 3))
    move!(active(g), roll)
    score!(active(g), active(g).position)
    g.turn = mod1(g.turn + 1, length(g.players))
end

active(g::Game) = g.players[g.turn]
winner(g::Game) = findall(p -> p.score >= 1000, g.players)
play!(g::Game) = while length(winner(g)) == 0 turn!(g) end

function part1() 
    game = Game(
        [Player(parse(Int, i[end]), 0) for i in input],
        1,
        Dice(1, 0)
    )
    play!(game)
    loser_score  = minimum(getproperty.(game.players, :score)) 
    times_rolled = game.dice.times_rolled
    return loser_score * times_rolled
end

const dirac_freqs = countmap(reduce(vcat, sum.(product(repeat([1:3], 3)...))))

function simulate(cur_posit, oth_posit, cur_score, oth_score)
    (oth_score >= 21) && return [0, 1]
    wins = [0, 0]
    for (roll, freq) in dirac_freqs 
        new_posit = mod1(cur_posit + roll, 10)
        new_score = cur_score + new_posit
        wins += 
            reverse(simulate(oth_posit, new_posit, oth_score, new_score)) * 
            freq
    end
    return wins
end

function part2() 
    starts = [parse(Int, i[end]) for i in input]
    counts = simulate(starts..., 0, 0)
    maximum(counts)
end

end 