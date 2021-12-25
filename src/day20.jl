module Day20 

using PaddedViews

export part1, part2

input = readlines("data/day20.txt")
parse_pixels(str) = [c == '#' ? 1 : 0 for c in str]
iealg = parse_pixels(input[1])
image = collect(transpose(reduce(hcat, parse_pixels.(input[3:end]))))

function decode(image, index)
    kern = image[(index - CartesianIndex(1, 1)):(index + CartesianIndex(1, 1))]
    iealg[parse(Int, join(join.(eachrow(kern))), base = 2) + 1]
end

function enhance(image, odd::Bool)
    padded = PaddedView(odd ? 0 : 1, image, size(image) .+ 4, (3, 3))
    imsize = size(padded)
    [decode(padded, i) for i in CartesianIndex(2,2):CartesianIndex(imsize .- 1)]
end

function enhance(image, times::Int) 
    enhanced = image 
    for i in 1:times 
        enhanced = enhance(enhanced, isodd(i))
    end 
    return enhanced
end

part1() = sum(enhance(image, 2))
part2() = sum(enhance(image, 50))

end