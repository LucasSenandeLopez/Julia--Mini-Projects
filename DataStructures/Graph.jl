using OrderedCollections


"""
It is heavily discouraged to create a Graph through its constructor definition, 
use the graph_from_adjmat function instead
"""
mutable struct Graph{T}
   
    adjacency_mat::Array{Int64, 2}
    node_data::OrderedDict{Int64, T}
    node_links::OrderedDict{Int64, Array{Int64, 1}}
    
end


function graph_from_adjmat(adjmat::Array{Int64,2}, data::Array{T, 1}) where T

    @assert size(adjmat,1) == size(adjmat, 2) "The Adjacency Matrix has to have equal numbers of rows
    and columns; adj_mat = Anxn"

    node_data::Dict{Int64, T} = OrderedDict(row_node => data[row_node] for row_node in 1:size(adjmat, 1))
    node_links::Dict{Int64, Array{Int64, 1}} = OrderedDict(row_node => [] for row_node in 1:size(adjmat, 1))

    @inbounds for row_node in 1:size(adjmat,1)

        @inbounds for col_link in 1:size(adjmat, 2)

            if  adjmat[row_node, col_link] == 1

                push!(node_links[row_node], col_link)
                
            end
        end
    end
    return Graph{T}(adjmat, sort(node_data), sort(node_links))
    
end

mat = [0 0 1; 
       0 0 1; 
       0 0 0]

data = [4,5,3]



graph = graph_from_adjmat(mat, data)
println(graph.node_data, "\n")
println(graph.node_links, "\n")

