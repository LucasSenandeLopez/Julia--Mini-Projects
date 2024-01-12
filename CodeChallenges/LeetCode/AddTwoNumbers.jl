#=

You are given two non-empty linked lists representing two non-negative integers. The digits are stored in reverse order, and each of their nodes contains a single digit. Add the two numbers and return the sum as a linked list.

You may assume the two numbers do not contain any leading zero, except the number 0 itself.

Example
Input: l1 = [2,4,3], l2 = [5,6,4]
Output: [7,0,8]
Explanation: 342 + 465 = 807.

Constraints:

The number of nodes in each linked list is in the range [1, 100].
0 <= Node.val <= 9
It is guaranteed that the list represents a number that does not have leading zeros.



NOTE: sum_lists is the algortihm to solve the problem; anything outside that function is
the infrastructure needed to run it and tests
=#

mutable struct LinkedList

    val::Int64
    len::Int64
    next::Union{Nothing,LinkedList}

    LinkedList(val::Int64, len::Int64, next = nothing) = new(val, len, next)

end

function create_linked_list(arr::Array{Int64,1})

    function fill_next_node!(arr::Array{Int64,1}, curr_node::LinkedList, i::Int64, stop::Int64)

        if i >= stop 
            return 
        end
        i += 1
        curr_node.next = LinkedList(arr[i], stop, fill_next_node!(arr, curr_node, i, stop))
        
    end

    stop = length(arr)
    @assert arr[1] != 0 "The list cannot have any leading zeros"
    @assert stop <= 100 "The Array must not be longer than 100 integers"
    @assert all(arr .>= 0) && all(arr .<= 9) "The members of the array must be nonnegative single digit"

    linked_list = LinkedList(arr[1], stop)
    fill_next_node!(arr, linked_list, 1, stop)
    return linked_list
end


function sum_lists(list1::LinkedList, list2::LinkedList)

    function list_to_array!(linked_list::LinkedList, arr::Array{Int64,1}, i::Int64)
    
        arr[i] = linked_list.val
        i += 1
        if i < linked_list.len
            list_to_array!(linked_list.next, arr, i)
        else
            arr[i] = linked_list.next.val
            return
        end
    end

    function to_number(arr::Array{Int64,1})
        
        number = ""

        for member in string.(arr[end:-1:begin])

            number *= member
        end

        return tryparse(BigInt ,number)
    end
    function number_to_array(number::BigInt)
        
        number = string(number)
        number = split(number, "")
        number = tryparse.(Int64 ,number)
        return number
    end

    arr1 = Array{Int64,1}(undef, list1.len)
    arr2 = Array{Int64,1}(undef, list2.len)

    list_to_array!(list1, arr1, 1)
    list_to_array!(list2, arr2, 1)
    
    arr1 = to_number(arr1)
    arr1 += to_number(arr2)
    arr1 = number_to_array(arr1)    
    return create_linked_list(arr1)
end

array1 = [1,2,3,4,5]
array2 = [1,2,3,4,5]
array3 = [1,0,0,0,0]
array4 = [1,0,0,0,0]
l = create_linked_list(array1)
l_2 = create_linked_list(array2)
sum_lists(l, l_2)

@assert typeof(sum_lists(l, l_2)) == typeof(create_linked_list([1, 0, 8, 6, 4, 2]))
@assert sum_lists(create_linked_list(array3), create_linked_list(array4)).val == 2
try
    
    create_linked_list([0,2,3,4,5])
catch AssertionError
end

#=
Time and Space Complexity:
    Note: n may refer to Nodes in the Linked List or Elements of an Array
    create_linked_list:
        Time Complexity: O(n)
        Space Complexity: O(n)
    sum_lists
        Time Complexity: O(n^2)
        Space Complexity: O(n^2)
=#
println("TESTS PASSED")
