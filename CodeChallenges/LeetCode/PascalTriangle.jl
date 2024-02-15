#=

118. Pascal's Triangle

Given an integer numRows, return the first numRows of Pascal's triangle.

In Pascal's triangle, each number is the sum of the two numbers directly above it as shown:

Example 1:

Input: numRows = 5
Output: [[1],[1,1],[1,2,1],[1,3,3,1],[1,4,6,4,1]]
Example 2:

Input: numRows = 1
Output: [[1]]

=#


function pasc_triangle(rows::Int64)
    

    triag = [Array{Int64, 1}(undef, row) for row in 1:rows] #O(n) because preallocation is O(1)
   

    @inbounds for row in triag

        row[begin], row[end] = (1, 1)
        
    end

    for row in 3:rows

        for index in 2:(row - 1)

            triag[row][index] = triag[row - 1][index - 1] + triag[row - 1][index]

        end
    end

    triag
 
end

#Time Complexity: O(n²)
#Space Complexity: O(n²)



