module MLPlots

using Reexport
@reexport using PlotRecipes

export
    TracePlot

# ---------------------------------------------------------------------

# a helper class to track many variables at once over time
type TracePlot{I,T}
    indices::I
    plt::Plot{T}
end
function TracePlot(n::Int = 1; maxn::Int = typemax(Int), kw...)
    indices = if n > maxn
        # sample maxn
        shuffle(1:n)[1:maxn]
    else
        1:n
    end
    plt = plot(length(indices); kw...)
    TracePlot(indices, plt)
end
function add_data(tp::TracePlot, x::Number, y::AbstractVector)
    for (i,idx) in enumerate(tp.indices)
        push!(tp.plt.series_list[i], x, y[idx])
    end
end
add_data(tp::TracePlot, x::Number, y::Number) = add_data(tp, x, [y])

# ---------------------------------------------------------------------
# optional

using Requires
@require OnlineAI         include("OnlineAI/onlineai.jl")
@require ROCAnalysis      include("ROCAnalysis/roc.jl")

end # module
