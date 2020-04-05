using LinearAlgebra
import Base: iterate

struct SumUp2K
    n :: Int
    k :: Int
end

function iterate(A::SumUp2K, prev::Vector{Int})
    a = prev[1]
    next = prev
    i_lasta = 1
    for i = 1:A.n
        if prev[i] == a
            i_lasta = i
        end
        if prev[i] > a+1
            next[i] -= 1
            next[i_lasta] += 1
            return next, next
        end
    end
    nothing
end

function iterate(A::SumUp2K)
    start = ones(Int, A.n)
    extras = A.k - A.n
    extras == 0 && return start, start
    bin = A.n
    while extras > 0
        if extras > (A.n-1)
            start[bin] = A.n
            bin -= 1
            extras -= A.n-1
        else
            start[bin] += extras
            return start, start
        end
    end
    nothing
end
iterate(A, nothing) = iterate(A)

function natural_latin_square(n::Int, k::Int)
    A = SumUp2K(n, k)
    for possible_diag in A
        ans = natural_latin_square(n, diagm(0 => possible_diag))
        if !isnothing(ans)
            return ans
        end
    end
    nothing
end

function natural_latin_square(n::Int, A::Matrix{Int})
    for j in 1:n
        for i in 1:n
            if A[i, j] == 0
                for candidate in 1:n
                    if ispossible(A, candidate, i, j)
                        newA = copy(A)
                        newA[i, j] = candidate
                        ans = natural_latin_square(n, newA)
                        if !isnothing(ans)
                            return ans
                        end
                    end
                end
                return nothing
            end
        end
    end
    A
end


function ispossible(A, a, i, j)
    !(a in A[i, :]) && !(a in A[:, j])
end

function printmat(A::Matrix)
    m, n = size(A)
    for i = 1:m
        for j = 1:n
            print(A[i,j], " ")
        end
        println()
    end
end

function solution()
    n_cases = parse(Int, readline())
    for x=1:n_cases
        n, k = [parse(Int, i) for i in split(readline())]
        A = natural_latin_square(n, k)
        if isnothing(A)
            println("Case #$x: IMPOSSIBLE")
        else
            println("Case #$x: POSSIBLE")
            printmat(A)
        end
    end
end

solution()

# input
# 2
# 3 6
# 2 3

# output
# Case #1: POSSIBLE
# 2 1 3
# 3 2 1
# 1 3 2
# Case #2: IMPOSSIBLE
