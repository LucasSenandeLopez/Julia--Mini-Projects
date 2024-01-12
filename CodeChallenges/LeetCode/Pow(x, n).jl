#=

Implement pow(x, n), which calculates x raised to the power n (i.e., x^n).

 

Example 1:

Input: x = 2.00000, n = 10
Output: 1024.00000
Example 2:

Input: x = 2.10000, n = 3
Output: 9.26100
Example 3:

Input: x = 2.00000, n = -2
Output: 0.25000
Explanation: 2^-2 = 1/2^2 = 1/4 = 0.25
 

Constraints:

-100.0 < x < 100.0
-2^31 <= n <= 2^31 -1
n is an integer.
Either x is not zero or n > 0.
-104 <= xn <= 104

=#

function pow(x::Float64, n::Int64)

    @assert (n > 0) || (x != 0.0) "The exponent has to be larger than zero and/or the base cannot be zero"
    @assert (x^n >= -10^4) && (x^n <= 10^4) "The base has to be within the [-10^4,10^4] interval"
    @assert (n >= -2^31) && (n <= 2^31 -1) "The exponent has to be within the Int32 limits"

    return x^n
end

try

    pow(5.0, 50)
catch AssertionError

end

try

    pow(0.0, -1)
catch AssertionError
end

try

    pow(1.000003, 2^32)
catch AssertionError
end

@assert pow(-1.0, 2) == 1.0
@assert pow(0.0, 3) == 0.0
@assert pow(2.0, -3) == 1/8.0

#Time Complexity: O(1)
#Space Complexity: O(1)
println("TESTS PASSED")