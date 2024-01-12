#=
Given a signed 32-bit integer x, return x with its digits reversed. 
If reversing x causes the value to go outside the signed 32-bit integer range [-2^31, 2^31 - 1], 
then return 0.

Example 1:

Input: x = 123
Output: 321
Example 2:

Input: x = -123
Output: -321
Example 3:

Input: x = 120
Output: 21



Constraints:

-2^31 <= x <= 2^31 - 1

=#
#The parameter int is asserted as Int64 to ensure the constraint is respected
function reverse_integers(int::Int64) 

    function remove_tailing_zeros(str::String)
        
        if str[end] == "0"

            return remove_tailing_zeros(str[begin:end-1])
        else

            return str
        end
    end
    @assert int != 0 "Integer has to be signed"
    if (int <= -2^31) || (int >= 2^31 - 1)
        return Int32(0)
    end

    int < 0 ? sign_var = -1 : sign_var = 1

    int = string(int)
    
    if string(int[begin]) == "-"
        int = int[begin + 1:end]
    end
  
    int = remove_tailing_zeros(int)
    
    int = int[end:-1:1]
    int = parse(Int64,int)
    
    return Int32(sign_var * int)
    
        
end

@assert reverse_integers(-300) == -3
@assert typeof(reverse_integers(-300)) == Int32
@assert reverse_integers(2^32) == 0
try
    
    reverse_integers(0)
catch AssertionError
end

#Time Complexity: O(n)
#Space Complexity: O(1)

println("TESTS PASSED")