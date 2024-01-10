mutable struct BSTNode{T}
    data::T
    left::Union{Nothing, Node{T}}
    right::Union{Nothing, Node{T}}
    Node{T}(data::T, left = nothing, right = nothing) where T = new{T}(data, left, right)
end

function node_push!(node::Node{T}, val::T) where T

    if val >= node.data

        node.right == nothing ? node.right = Node{T}(val) : node_push!(node.right, val)        

    else

        node.left == nothing ? node.left = Node{T}(val) : node_push!(node.right, val)

    end


end