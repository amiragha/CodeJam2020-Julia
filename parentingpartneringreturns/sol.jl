function scheduling(jobs)
    perm = sortperm(jobs, by=x->first(x))
    ans = Vector{Char}()
    cfreeon = 0
    jfreeon = 0
    for job in jobs[perm]
        if first(job) >= cfreeon
            push!(ans, 'C')
            cfreeon = last(job)
        elseif first(job) >= jfreeon
            push!(ans, 'J')
            jfreeon = last(job)
        else
            return "IMPOSSIBLE"
        end
    end
    string(ans[invperm(perm)]...)
end

function solution()
    n_cases = parse(Int, readline())
    for x = 1:n_cases
        n_jobs = parse(Int, readline())
        jobs = Vector{Tuple{Int, Int}}()
        for i = 1:n_jobs
            push!(jobs, Tuple(parse(Int, t) for t in split(readline())))
        end
        println("Case #$x: $(scheduling(jobs))")
    end
end

solution()
