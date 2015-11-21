typealias CLoss Union{MarginBasedLoss, LossFunctions.ZeroOneLoss}
typealias DLoss DistanceBasedLoss

_loss_xlabel(loss::CLoss) = "y ⋅ h(x)"
_loss_xlabel(loss::DLoss) = "h(x) - y"

function Plots.plot(loss::SupervisedLoss; kw...)
    Plots.plot(loss, -2, 2; kw...)
end

function Plots.plot(loss::SupervisedLoss, args...;
                    xlabel = _loss_xlabel(loss),
                    ylabel = "L(y, h(x))",
                    label = string(loss),
                    kw...)
    plot(value_fun(loss), args...;
         xlabel = xlabel,
         ylabel = ylabel,
         label = label,
         kw...)
end

function Plots.plot{T<:SupervisedLoss}(vec::Vector{T}; kw...)
    Plots.plot(vec, -2, 2; kw...)
end

function Plots.plot{T<:SupervisedLoss}(vec::Vector{T}, args...; kw...)
    @assert length(vec) > 0
    plt = plot(vec[1], args...; kw...)
    for loss in vec[2:end]
        plot!(plt, loss, args...)
    end
    plt
end

function Plots.plot!(plt::Plots.Plot, loss::SupervisedLoss, args...;
                     label = string(loss),
                     kw...)
    plot!(plt, value_fun(loss), args...;
          label = label,
          kw...)
end

function Plots.plot!{T<:SupervisedLoss}(plt::Plots.Plot, vec::Vector{T}, args...; kw...)
    @assert length(vec) > 0
    plt = plot!(vec[1], args...; kw...)
    for loss in vec[2:end]
        plot!(plt, loss, args...)
    end
    plt
end
