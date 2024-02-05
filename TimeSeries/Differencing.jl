module Differencing
export difference_series, difference_order

"""Applies first order differencing"""
function difference_series(series::Array{Float64, 1}, lag::Int64)
    @assert lag >= 1 "To do differencing you need a lag parameter higher than 1"

    difftd_series = Array{Float64,1}(undef, length(series) - lag)

    @inbounds for i = (1 + lag):length(series)
    
        difftd_series[i- lag] = series[i] - series[i- lag]
    end

    return difftd_series
end


"""Applies differencing of a specified order"""
function difference_order(series::Array{Float64, 1}, lag::Int64, order::Int64)

    while order > 0

        series = difference_series(series, lag)
        order -= 1
    end
    
    return series
end

arr = Float64.([2,9,5,8,10,20,4,2,3])

@assert difference_series(arr, 1) == difference_order(arr, 1, 1)
@assert difference_series(difference_series(arr, 1), 1) == difference_order(arr, 1, 2)
difference_order.([[1.0 for j in 1:5] for i in 1:3], 1, 1)

end