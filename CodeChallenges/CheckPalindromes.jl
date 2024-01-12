#=

Challenge: Check whether the given string is a palindrome

=#

function check_palindrome(strvar::String)
    length_strvar = length(strvar)
    mid_index = floor(Int64, length_strvar/2)
    for i in 1:mid_index

        if lowercase(strvar)[i] != lowercase(strvar)[end - i + 1]

            return false
        end
    end

    return true
end 

#Time complexity = O(n)
#Space complexity = O(1)

@assert !check_palindrome("cat") 
@assert check_palindrome("Tat")
@assert check_palindrome("ABCDE_f_EDCBA") 
@assert check_palindrome("HiiH") 

println("TESTS PASSED")
