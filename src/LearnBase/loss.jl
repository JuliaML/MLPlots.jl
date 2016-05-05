using LearnBase

_loss_xlabel(loss::Union{MarginLoss, LossFunctions.ZeroOneLoss}) = "y ⋅ h(x)"
_loss_xlabel(loss::DistanceLoss) = "h(x) - y"

# function Plots._apply_recipe(d::KW, loss::ModelLoss; kw...)
#     Plots._apply_recipe(d, loss, -2, 2; kw...)
# end
#
# function Plots._apply_recipe(d::KW, loss::ModelLoss, args...; kw...)
#     get!(d, :xlabel, _loss_xlabel(loss))
#     get!(d, :ylabel, "L(y, h(x))")
#     get!(d, :label, string(loss))
#     value_fun(loss), args...
# end

@recipe function plot(loss::ModelLoss, xmin = -2, xmax = 2)
    :xlabel --> _loss_xlabel(loss)
    :ylabel --> "L(y, h(x))"
    :label  --> string(loss)
    value_fun(loss), xmin, xmax
end

# function Plots._apply_recipe{T<:ModelLoss}(d::KW, losses::AbstractVector{T}; kw...)
#     Plots._apply_recipe(d, losses, -2, 2; kw...)
# end
#
# function Plots._apply_recipe{T<:ModelLoss}(d::KW, losses::AbstractVector{T}, args...; issubplot = false, kw...)
#     get!(d, :ylabel, "L(y, h(x))")
#     get!(d, :label, map(string, losses)')
#     if issubplot && (get!(d, :n, length(losses)) == length(losses))
#         get!(d, :legend, false)
#         get!(d, :title, d[:label])
#         get!(d, :xlabel, map(_loss_xlabel, losses)')
#     else
#         get!(d, :xlabel, _loss_xlabel(first(losses)))
#     end
#     map(value_fun, losses), args...
# end

@recipe function plot{T<:ModelLoss}(losses::AbstractVector{T}, xmin = -2, xmax = 2)
    :ylabel --> "L(y, h(x))"
    :label  --> map(string, losses)'
    if issubplot
        :n      --> length(losses)
        :legend --> false
        :title  --> d[:label]
        :xlabel --> map(_loss_xlabel, losses)'
    else
        :xlabel --> _loss_xlabel(first(losses))
    end
    map(value_fun, losses), xmin, xmax
end
