module Day16 

input = readline("data/day16.txt")

parse_hex_char(c::Char) = reduce(string, reverse(digits(parse(Int, c, base = 16), base = 2, pad = 4)))
parse_bin(str::AbstractString) = parse(Int, str, base = 2)
parse_hex(str::AbstractString) = reduce(string, parse_hex_char(c) for c in str)

msg = parse_hex(input)

abstract type Packet end

struct LiteralPacket <: Packet
    encoded::AbstractString
    version::Int64
    type_id::Int64 
    value::Int64 
end

struct OperatorPacket <: Packet
    encoded::AbstractString
    version::Int64 
    type_id::Int64
    length_type_id::Int64
    length::Int64
    packets::Vector{Packet}
end

sample = parse_hex("D2FE28")
sample

type = parse_bin(sample[4:6]) == 4 ? "literal" : "operator"

function LiteralPacket(encoded::AbstractString)
    counter = 7 
    stopval = '1'
    value = []
    while stopval == '1'
        @show push!(value, encoded[(counter + 1):(counter + 4)])
        stopval = encoded[counter]
        counter += 5
    end
    LiteralPacket(
        encoded, 
        parse_bin(encoded[1:3]),
        parse_bin(encoded[4:6]),
        parse_bin(string(value...))
    )
end

LiteralPacket(sample)

end