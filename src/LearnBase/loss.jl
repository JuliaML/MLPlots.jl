using LearnBase

_loss_xlabel(loss::Union{MarginLoss, LossFunctions.ZeroOneLoss}) = "y ⋅ h(x)"
_loss_xlabel(loss::DistanceLoss) = "h(x) - y"

@recipe function plot(loss::ModelLoss, xmin = -2, xmax = 2)
    :xlabel --> _loss_xlabel(loss)
    :ylabel --> "L(y, h(x))"
    :label  --> string(loss)
    value_fun(loss), xmin, xmax
end

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
