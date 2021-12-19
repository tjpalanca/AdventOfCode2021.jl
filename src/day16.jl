module Day16 

export part1, part2

input = readline("data/day16.txt")

parse_hex_char(c::Char) = reduce(string, reverse(digits(parse(Int, c, base = 16), base = 2, pad = 4)))
parse_bin(str::AbstractString) = parse(Int, str, base = 2)
parse_hex(str::AbstractString) = reduce(string, parse_hex_char(c) for c in str)

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

numchar(p::Packet) = length(encoded(p))
encoded(p::Packet) = p.encoded 
version(p::Packet) = p.version
packets(p::OperatorPacket) = p.packets
type_id(p::Packet) = p.type_id
version_sum(p::LiteralPacket) = version(p)
version_sum(p::OperatorPacket) = version(p) + sum(version_sum.(packets(p))) 

function LiteralPacket(str::AbstractString)
    counter = 7 
    stopval = '1'
    value = AbstractString[]
    while stopval == '1'
        push!(value, str[(counter + 1):(counter + 4)])
        stopval = str[counter]
        counter += 5
    end
    remaining = str[counter:end]
    packet = LiteralPacket(
        str[1:(counter - 1)], 
        parse_bin(str[1:3]),
        parse_bin(str[4:6]),
        parse_bin(string(value...))
    )
    return packet, remaining
end

function OperatorPacket(str::AbstractString)
    length_type_id = str[7]
    if length_type_id == '0' 
        length = parse_bin(str[8:22])
        chars = 0 
        remaining = str[23:end]
        packets = Packet[]
        while chars < length 
            packet, remaining = Packet(remaining)
            push!(packets, packet)
            chars += numchar(packet)
        end
        packet = OperatorPacket(
            string(str[1:22], reduce(string, encoded.(packets))),
            parse_bin(str[1:3]),
            parse_bin(str[4:6]),
            length_type_id,
            length,
            packets
        )
        return packet, remaining
    elseif length_type_id == '1'
        length = parse_bin(str[8:18])
        packs = 0
        remaining = str[19:end]
        packets = Packet[]
        while packs < length 
            packet, remaining = Packet(remaining)
            push!(packets, packet)
            packs += 1 
        end 
        packet = OperatorPacket(
            string(str[1:18], reduce(string, encoded.(packets))),
            parse_bin(str[1:3]),
            parse_bin(str[4:6]),
            length_type_id,
            length,
            packets
        )
        return packet, remaining
    else 
        error("Length Type ID is invalid")
    end
end

function Packet(str::AbstractString)
    if parse_bin(str[4:6]) == 4 
        LiteralPacket(str)
    else
        OperatorPacket(str)
    end
end

function part1()
    msg = parse_hex(input)
    packet, extra = Packet(msg)
    version_sum(packet)
end

calculate(p::LiteralPacket) = p.value
function calculate(p::OperatorPacket)
    subvalues = [calculate(p) for p in packets(p)]
    if type_id(p) == 0
        reduce(+, subvalues)
    elseif type_id(p) == 1 
        reduce(*, subvalues)
    elseif type_id(p) == 2 
        minimum(subvalues)
    elseif type_id(p) == 3 
        maximum(subvalues)
    elseif type_id(p) == 5
        subvalues[1] > subvalues[2] ? 1 : 0
    elseif type_id(p) == 6 
        subvalues[1] < subvalues[2] ? 1 : 0
    elseif type_id(p) == 7 
        subvalues[1] == subvalues[2] ? 1 : 0
    end
end

function part2() 
    msg = parse_hex(input)
    packet, extra = Packet(msg)
    calculate(packet)
end

end