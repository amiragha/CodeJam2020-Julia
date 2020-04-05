import Base.reverse!

mutable struct BitDataBase
    B            :: Int
    guess        :: Vector{Int}
    n_queries    :: Int
    flipdetect   :: Tuple{Int, Int} # index of the flip detector
    paritydetect :: Tuple{Int, Int} # index of the operation parity detector (either zero/two operations or one operation)
    isknown      :: Int
    function BitDataBase(B::Int)
        new(B, fill(-1, B), 0, (0, -1), (0, -1), false)
    end
end

"""
The error is either
- Unknown  (only at the beginning)
- Z2 flip/noflip (when only similars are available)
- Z2 (id, reverseflip)/(reverse,flip)
- Z2xZ2 fully known
"""
function correcterror!(data::BitDataBase)
    isflipped = false
    if data.flipdetect[1] > 0
        b = query!(data, data.flipdetect[1])
        if b != data.flipdetect[2]
            flip!(data)
            isflipped = true
            data.flipdetect= (data.flipdetect[1], b)
        end
    else
        query!(data, 1)
    end
    if data.paritydetect[1] > 0
        b = query!(data, data.paritydetect[1])
        if b != data.paritydetect[2]
            !isflipped && reverse!(data)
            data.paritydetect = (data.paritydetect[1] ,b)
        else
            isflipped && reverse!(data)
        end
    else
        query!(data, 1)
    end
    data
end

"query at position `n` but don't insert the value"
function query!(data::BitDataBase, n)
    println(n)
    b = parse(Int, readline())
    data.n_queries += 1
    b
end


"query for a single bit at position  `n`"
function queryinsert!(data::BitDataBase, n)
    println(n)
    b = parse(Int, readline())
    data.guess[n] = b
    data.n_queries += 1
    data
end

"query for a single bit at position `n` and the reverse position"
function doublequeryinsert!(data::BitDataBase, n)
    println(n)
    b1 = parse(Int, readline())
    data.guess[n] = b1
    m = data.B-n+1
    println(m)
    b2 = parse(Int, readline())
    data.guess[m] = b2
    data.n_queries += 2
    ## similar pairs detect flip, opposite pairs distinguish between
    ## the parity of applied operators (either 02 or 1) (id,
    ## reverseflip) and (reverse, flip).
    if data.flipdetect[1] == 0 && b1 == b2
        data.flipdetect = (n, b1)
    end
    if data.paritydetect[1] == 0 && b1 != b2
        data.paritydetect = (n, b1)
    end
    data
end

function flip!(data::BitDataBase)
    newguess = fill(-1, data.B)
    for i in eachindex(data.guess)
        if data.guess[i] != -1
            b = data.guess[i]
            newguess[i] = b==0 ? 1 : 0
        end
    end
    data.guess = newguess
end

reverse!(data::BitDataBase) = reverse!(data.guess)

function interact(B)
    data = BitDataBase(B)
    for round = 1:14
        correcterror!(data)
        offset = (round-1)*4
        for i=1:4
            doublequeryinsert!(data, offset+i)
            if offset+i == div(data.B, 2)
                if isodd(data.B)
                    doublequeryinsert!(data, offset+i)
                end
                return data
            end
        end
    end
    data
end

function solution()
    n_cases, B = Tuple(parse(Int, i) for i in split(readline()))
    for x in 1:n_cases
        data = interact(B)
        println(reduce(*, string.(data.guess)))
        flush(stdout)
        answer = readline()
        if answer=="N"
            return
        end
    end
end

solution()
