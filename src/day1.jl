module Day1 

numbers = parse.(Int, readlines("data/day1.txt"))

part1_ans = sum(2:length(numbers)) do i
    numbers[i] > numbers[i-1]
end

part2_ans = sum(2:length(numbers) - 2) do i 
    sum(numbers[i:i+2]) > sum(numbers[i-1:i+1])
end

end