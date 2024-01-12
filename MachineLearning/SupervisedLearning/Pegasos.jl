module pegasos
    using Random 
    export run_pegasos

    function pegasos_simple_step_update_stopper(f_vector::SubArray{Float64},label::Float64,λ::Float64,
        η::Float64,θ::Array{Float64},offset::Float64)
       if label*(f_vector'*θ + offset) < 0.99
            
            θ .*= (1 - η*λ) 
            θ .+= η*label.*f_vector 
            offset += η*label
            return offset, false
    
       else
       
           θ .*=(1 - η*λ)
    
           return offset, true
           
       end
    
    end
    
    function pegasos_simple_step_update(f_vector::SubArray{Float64},label::Float64,λ::Float64,
        η::Float64,θ::Array{Float64},offset::Float64)
       if label*(f_vector'*θ + offset) < 0.99
            
            θ .*= (1 - η*λ) 
            θ .+= η*label.*f_vector 
            return η*label
       else
       
           θ .*=(1 - η*λ)
    
           return 0
           
       end
    
    end
    
    function shuffle_indices(max_index::Int64)
    
        return shuffle(collect(1:max_index))
    
    end
    
    function run_pegasos_stopper(f_matrix::Array{Float64}, labels::Array{Float64}, T::Int64, λ::Float64)
        set_zero_subnormals(true)
        θ::Array{Float64} = fill(0.0, size(f_matrix', 1))
        offset = 0.0
        decay = 1
        η = 1.0
        earlystop::Array{Bool} = fill(false, length(labels))
        
    
        @fastmath begin
            @inbounds for t in 1:T
                @inbounds for i in shuffle_indices(size(f_matrix',2))
        
                    η = 1.0/sqrt(decay)
                    offset, earlystop[i] = @views @inline pegasos_simple_step_update_stopper(f_matrix'[:,i], labels[i], λ, η, θ, offset)
                    if false ∉ earlystop
                        set_zero_subnormals(false)
                        return (θ, offset)
                    end
                    decay += 1
    
        
                end
            end
        end    
        return (θ, offset)
        
    end
    
    function run_pegasos(f_matrix::Array{Float64}, labels::Array{Float64}, T::Int64, λ::Float64)
        set_zero_subnormals(true)
        θ::Array{Float64} = fill(0.0, size(f_matrix', 1))
        offset = 0.0
        decay = 1
        η = 1.0
    
        
    
        @fastmath begin
            @inbounds for t in 1:T
                @inbounds for i in shuffle_indices(size(f_matrix',2))
        
                    η = 1.0/sqrt(decay)
                    offset += @views @inline pegasos_simple_step_update(f_matrix'[:,i], labels[i], λ, η, θ, offset)
                    decay += 1
    
        
                end
            end
        end   
        set_zero_subnormals(false) 
        return (θ, offset)
        
    end

    function labelformatter(label::Float64)

        label <= 0 ? -1.0 : 1.0
    
    end
    
    function accuracy(x::Array{Float64,2}, y::Array{Float64,1}, 
        est_theta::Array{Float64, 1}, offset::Float64)
        
    
        return @inline 1.0 - sum(abs.(y .- labelformatter.(x*est_theta .+ offset)))/length(y)
    
    
    end
end
