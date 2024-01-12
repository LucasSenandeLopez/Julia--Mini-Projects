mutable struct QueueEl{T}
    data::T
    next::Union{Nothing,QueueEl{T}}
    QueueEl{T}(data::T, next = nothing) where T = new{T}(data, next)

end

function add_to_top!(queue::QueueEl{T}, val::T) where T
    queue.next = QueueEl{T}(queue.data, queue.next)
    queue.data = val
    
end

function remove_from_top!(queue::QueueEl{T}) where T
    extracted_val = queue.data
    queue.data = queue.next.data
    queue.next = queue.next.next
    return extracted_val
end
