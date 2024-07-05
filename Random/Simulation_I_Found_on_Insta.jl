using Plots

const A::Matrix{Float16} = [[0.5, 0.5] [-0.5, 0.5]]

@inline function f1(x::Vector{Float16})::Vector{Float16}
    return A * x
end

@inline function f2(x::Vector{Float16})::Vector{Float16}
    return A * x + Float16.([1.0, 0.0])
end

function f_fill!(vec_x::Vector{Float16}, vec_y::Vector{Float16})
    
    x::Vector{Float16} = [1.0, 0.0]

    @inbounds for i in 1:3:75000

        vec_x[i] = x[1]
        vec_y[i] = x[2]

        x_left::Vector{Float16} = f1(x)
        x_right::Vector{Float16} = f2(x)
        r_int::Float16 = rand(Float16.([1.0, 0.0]))

        vec_x[i + 1] = x_left[1] # We input x_left
        vec_y[i + 1] = x_left[2]

        vec_x[i + 2] = x_right[1] # We input x_right
        vec_y[i + 2] = x_right[2]

        x = r_int .* x_left + (1 - r_int) .* x_right
        
    end

end

vec_x = Vector{Float16}(undef, 75_000)
vec_y = Vector{Float16}(undef, 75_000)

f_fill!(vec_x, vec_y)
scatter(vec_x, vec_y, alpha = 0.3, markerstrokewidth = false, label = false)
savefig("Random\\Plots\\Simulation_I_Found_on_Insta.png")