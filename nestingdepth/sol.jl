function parstring(n::Int)
    if n < 0
        return string([')' for i=1:abs(n)]...)
    elseif n > 0
        return string(['(' for i=1:n]...)
    end
    ""
end

function nestingdepth(nums::Vector{Int})
    ans = Vector{String}()
    prev = 0
    for i in 1:length(nums)
        push!(ans, parstring(nums[i] - prev) * string(nums[i]))
        prev = nums[i]
    end
    push!(ans, parstring(-prev))
    reduce(*, ans)
end

function solution()
    n_cases = parse(Int, readline())
    for x in 1:n_cases
        nums = [parse(Int, i) for i in readline()]
        println( "Case #$x: $(nestingdepth(nums))")
    end
end

solution()
