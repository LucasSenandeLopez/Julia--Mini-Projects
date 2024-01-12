mutable struct BSTNode{T}
    data::T
    left::Union{Nothing, Node{T}}
    right::Union{Nothing, Node{T}}
    BSTNode{T}(data::T, left = nothing, right = nothing) where T = new{T}(data, left, right)
end

function node_push!(node::BSTNode{T}, val::T) where T

    if val >= node.data

        isnothing(node.right) ? node.right = Node{T}(val) : node_push!(node.right, val)        

    else

        isnothing(node.left) ? node.left = Node{T}(val) : node_push!(node.right, val)

    end


end