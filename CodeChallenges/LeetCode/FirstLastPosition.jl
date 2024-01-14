#=

Find First and Last position of element in sorted Array

Given an array of integers nums sorted in non-decreasing order, find the starting and ending position of a given target value.

If target is not found in the array, return [-1, -1].

You must write an algorithm with O(log n) runtime complexity.

 

Example 1:

Input: nums = [5,7,7,8,8,10], target = 8
Output: [4,5]
Example 2:

Input: nums = [5,7,7,8,8,10], target = 6
Output: [-1,-1]
Example 3:

Input: nums = [], target = 0
Output: [-1,-1]
 

Constraints:

0 <= nums.length <= 10^5
-10^9 <= nums[i] <= 10^9
nums is a non-decreasing array.
-10^9 <= target <= 10^9

=#


function first_last_position(nums::Array{Int64, 1}, target::Int64)

    i = 0

    

    updiv = num -> num % 2 == 0 ? Int64(num/2) : Int64(num ÷ 2) 
        
    



    function find_first_element(nums::Array{Int64, 1}, target::Int64, first_pos::Int64 ,last_pos::Int64, i::Int64)
        
        i += 1
        mid_point = updiv(last_pos + first_pos)
        
        if i > length(nums) || first_pos > length(nums) || mid_point > length(nums)

            return -1

        elseif nums[first_pos] == target

            return first_pos            
            
        end

        


        if nums[mid_point] >= target

            find_first_element(nums, target, first_pos + 1, mid_point, i)
        elseif nums[mid_point] < target

            find_first_element(nums, target, mid_point + 1, last_pos, i)

        end

    end
    
    function find_last_element(nums::Array{Int64, 1}, target::Int64, first_pos::Int64 ,last_pos::Int64)
        



        if nums[last_pos] == target

            return last_pos
                 
           
        end

        mid_point = updiv(last_pos + first_pos)
    

        if nums[mid_point] > target

            find_last_element(nums, target, first_pos, mid_point - 1)
        elseif nums[mid_point] <= target

            find_last_element(nums, target, mid_point, last_pos - 1)

        end

    end
    

 



    nums_len = length(nums)


    @assert all(nums .>= -10^9) && all(nums .<= 10^9) "All elements must be within [-10^9, 10^9]"
    @assert nums_len <= 10^5 "The array must not be longer than 10^5 elements"
    @assert (target >= -10^9) && (target <= 10^9) "Target must be within [-10^9, 10^9]"



    first_index = find_first_element(nums, target, 1, nums_len, i)
    first_index == -1 ? [-1, -1] :  [first_index, find_last_element(nums, target, first_index, nums_len)]

end

@assert first_last_position([1,1,1,1,1],1) == [1,5]
@assert first_last_position([1,2,3,4,5],3) == [3,3]
@assert first_last_position([1,2,3,3,4,5],3) == [3,4] 
@assert first_last_position([1,2,3,3,4,5],7) == [-1,-1]
@assert first_last_position([1],1) == [1,1]
@assert first_last_position([1,2,3,3,3,4,5], 3) == [3,5] 
arr = collect(1:10^5)
arr[500:600] .= 501
@assert first_last_position(arr, 501) == [500,600] 

try
    first_last_position(fill(1,10^5 + 1), 1)

catch
end

try
    first_last_position([-10^10,10^10], 10^10)

catch
end

#Time Complexity: O(Log(n))
#Space Complexity: O(1)

println("TESTS PASSED")

