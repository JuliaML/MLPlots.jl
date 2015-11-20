module MLPlots

using Reexport
@reexport using Plots
using LearnBase

export
    corrplot

include("recipes.jl")
include("loss.jl")

end # module
