using LinearAlgebra

function readmat(n::Int)
    m = zeros(Int, n, n)
    for i = 1:n
        m[i, :] = [parse(Int, x) for x in split(readline())]
    end
    m
end

function solution()
    n_cases = parse(Int, readline())
    for x=1:n_cases
        n = parse(Int, readline())
        m = readmat(n)
        k = tr(m)
        r = n - count(allunique(m[i, :]) for i in 1:n)
        c = n - count(allunique(m[:, i]) for i in 1:n)
        println("Case #$x: $k $r $c")
    end
end

solution()
