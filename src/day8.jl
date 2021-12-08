module Day8 

input()   = split.(readlines("data/day8.txt"), " | ")
pattern() = split.(getindex.(input(), 1), " ")
output()  = split.(getindex.(input(), 2), " ")

findseg(n, p) = filter(pᵢ -> length(pᵢ) == n, p)
ncommon(p₁, p₂) = length(intersect(p₁, p₂))

function find_mapping(p)
    
    # Identify digits
    d1, d4, d7, d8 = map(l -> only(findseg(l, p)), (2, 4, 3, 7))
    d6 = only(filter(pᵢ -> ncommon(pᵢ, d1) == 1, findseg(6, p)))
    d9 = only(filter(pᵢ -> ncommon(pᵢ, d4) == 4, findseg(6, p)))
    d0 = only(setdiff(findseg(6, p), [d6, d9]))
    d3 = only(filter(pᵢ -> ncommon(pᵢ, d1) == 2, findseg(5, p)))
    d2 = only(filter(pᵢ -> ncommon(pᵢ, d9) == 4, findseg(5, p)))
    d5 = only(setdiff(findseg(5, p), [d3, d2]))
    
    # Construct mapping from digits
    mapping = Dict()
    mapping["top"]         = only(setdiff(d7, d1))
    mapping["bottomleft"]  = only(setdiff(d8, d9))
    mapping["topright"]    = only(setdiff(d8, d6))
    mapping["topleft"]     = only(setdiff(d9, d3))
    mapping["center"]      = only(setdiff(d8, d0))
    mapping["bottom"]      = only(setdiff(d3, d7, d4))
    mapping["bottomright"] = only(setdiff(d3, d2))

    return mapping
    
end

# Decoders
segments = ["top", "topright", "topleft", "center", "bottomright", "bottomleft", "bottom"]
decoder = Dict(
    "1" => ["topright", "bottomright"],
    "2" => ["top", "topright", "center", "bottomleft", "bottom"],
    "3" => ["top", "topright", "center", "bottomright", "bottom"],
    "4" => ["topleft", "topright", "center", "bottomright"],
    "5" => ["top", "topleft", "center", "bottomright", "bottom"],
    "6" => setdiff(segments, ["topright"]),
    "7" => ["top", "topright", "bottomright"],
    "8" => segments,
    "9" => setdiff(segments, ["bottomleft"]),
    "0" => setdiff(segments, ["center"])
)

function decode_output(output, mapping, decoder)

    segs = [[only(collect(keys(mapping))[findall(values(mapping) .== char)]) for char in o] for o in output]
    digs = [only(collect(keys(decoder))[findall(issetequal.(values(decoder), Ref(seg)))]) for seg in segs]
    return parse(Int, string(digs...))

end

part1() = count(in.(length.(collect(Iterators.flatten(output()))), Ref((2, 4, 7, 3))))
part2() = sum(decode_output.(output(), find_mapping.(pattern()), Ref(decoder)))

end