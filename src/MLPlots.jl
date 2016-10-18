module MLPlots

using Reexport
@reexport using PlotRecipes
import Plots: Series
using LearnBase

export
    TracePlot

# ---------------------------------------------------------------------

# a helper class to track many variables at once over time
type TracePlot{I,T}
    indices::I
    plt::Plot{T}
    sp::Subplot{T}
    series::Vector{Series}
end
function TracePlot(n::Int = 1; maxn::Int = typemax(Int), sp = nothing, kw...)
    indices = if n > maxn
        # sample maxn
        shuffle(1:n)[1:maxn]
    else
        1:n
    end
    if sp == nothing
        plt = plot(length(indices); kw...)
        sp = plt[1]
    else
        plt = plot!(sp, length(indices); kw...)
    end
    TracePlot(indices, plt, sp, sp.series_list)
end
function Base.push!(tp::TracePlot, x::Number, y::AbstractVector)
    for (i,idx) in enumerate(tp.indices)
        push!(tp.series[i], x, y[idx])
    end
end
Base.push!(tp::TracePlot, x::Number, y::Number) = push!(tp, x, [y])

# ---------------------------------------------------------------------
# optional

function is_installed(name::AbstractString)
    try
        Pkg.installed(name) === nothing ? false: true
    catch
        false
    end
end

# using Requires
# @require OnlineAI         include("OnlineAI/onlineai.jl")
# @require ROCAnalysis      include("ROCAnalysis/roc.jl")

if is_installed("Transformations")
    include("optional/transformations.jl")
end
# if is_installed("OnlineAI")
#     include("optional/onlineai.jl")
# end
if is_installed("ROCAnalysis")
    include("optional/roc.jl")
end

end # module
