module Day1 

export part1, part2

function input() 
    parse.(Int, readlines("data/day1.txt"))
end

function part1()
    numbers = input()
    sum(2:length(numbers)) do i
        numbers[i] > numbers[i-1]
    end
end

function part2()
    numbers = input()
    sum(2:length(numbers) - 2) do i 
        sum(numbers[i:i+2]) > sum(numbers[i-1:i+1])
    end
end

end