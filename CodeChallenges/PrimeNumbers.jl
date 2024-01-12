#= 
Challenge: Find all the prime numbers up to a specific integer
=#

function find_primes(n::Int64)
    @assert n > 1 "Introduce a natural number strictly larger than one"
    prime_array = Array{Int64,1}()

    @inbounds for int in 2:n
        if 0 ∉ int.%prime_array

            push!(prime_array, int)

        end
    end
    return prime_array
end

#Time complexity: O(n)
#=Space complexity: O(n) (The constant which is simplified away in the Big O notation is variable 
and decreasing with n) =#

try 

    find_primes(1)
    find_primes(0)
catch AssertionError

    println("Number should be a natural greater than one\n")
end

@assert length(find_primes(2)) == 1
@assert length(find_primes(100)) == 25

println("TESTS PASSED")
