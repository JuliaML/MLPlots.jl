using LearnBase

typealias CLoss Union{MarginBasedLoss, LossFunctions.ZeroOneLoss}
typealias DLoss DistanceBasedLoss

_loss_xlabel(loss::CLoss) = "y ⋅ h(x)"
_loss_xlabel(loss::DLoss) = "h(x) - y"

function Plots._apply_recipe(d::Dict, loss::SupervisedLoss; kw...)
    Plots._apply_recipe(d, loss, -2, 2; kw...)
end

function Plots._apply_recipe(d::Dict, loss::SupervisedLoss, args...; kw...)
    get!(d, :xlabel, _loss_xlabel(loss))
    get!(d, :ylabel, "L(y, h(x))")
    get!(d, :label, string(loss))
    value_fun(loss), args...
end

function Plots._apply_recipe{T<:SupervisedLoss}(d::Dict, losses::AbstractVector{T}; kw...)
    Plots._apply_recipe(d, losses, -2, 2; kw...)
end

function Plots._apply_recipe{T<:SupervisedLoss}(d::Dict, losses::AbstractVector{T}, args...; issubplot = false, kw...)
    get!(d, :ylabel, "L(y, h(x))")
    get!(d, :label, map(string, losses)')
    if issubplot && (get!(d, :n, length(losses)) == length(losses))
        get!(d, :legend, false)
        get!(d, :title, d[:label])
        get!(d, :xlabel, map(_loss_xlabel, losses)')
    else
        get!(d, :xlabel, _loss_xlabel(first(losses)))
    end
    map(value_fun, losses), args...
end
