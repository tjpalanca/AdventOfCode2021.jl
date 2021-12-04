module Day4 

# Read Input
input = readlines("data/day4.txt")

# Bingo Card Types
abstract type BingoVector end
struct BingoRow <: BingoVector elements::Vector{Int} end
struct BingoCol <: BingoVector elements::Vector{Int} end
struct BingoCard rows::Vector{BingoRow} end 

# Bingo Card Methods
cols(card::BingoCard) = [BingoCol([row.elements[i] for row in card.rows]) for i in 1:5]
elms(card::BingoCard) = reduce((prev, row) -> vcat(row.elements, prev), card.rows; init = [])

is_winner(vec::BingoVector, picked) = all([x in picked for x in vec.elements])
function is_winner(card::BingoCard, picked)
    any(is_winner(row, picked) for row in card.rows) | 
    any(is_winner(col, picked) for col in cols(card))
end

find_winners(cards, picked) = filter(card -> is_winner(card, picked), cards)
function find_first_winners(cards, picked)
    winner = []
    num_picked = 4
    while (length(winner) == 0) 
        num_picked += 1
        winner = find_winners(cards, picked[1:num_picked])
    end
    return winner, picked[1:num_picked]
end
function find_last_winners(cards, picked)
    last_winner = []
    winners = []
    num_picked = 4 
    while (length(last_winner) == 0)
        num_picked += 1 
        old_winners = winners
        winners = find_winners(cards, picked[1:num_picked])
        if (length(winners) == length(cards)) 
            last_winner = setdiff(winners, old_winners)
        end
    end
    return last_winner, picked[1:num_picked]
end 

score(card::BingoCard, picked) = sum(setdiff(elms(card), picked)) * picked[length(picked)]

# Parse Inputs
cards = map(3:6:length(input)) do i 
    card = split.(input[i:(i + 4)], " "; keepempty = false)
    BingoCard([BingoRow(parse.(Int, row)) for row in card])
end 
picked = parse.(Int, split(input[1], ","))

# Part 1: Pick first winner and compute score
(winner, winner_picked) = find_first_winners(cards, picked)
@assert length(winner) == 1
score(winner[1], winner_picked)

# Part 2: Pick last winner and compute score 
(loser, loser_picked) = find_last_winners(cards, picked)
@assert length(loser) == 1
score(loser[1], loser_picked)

end