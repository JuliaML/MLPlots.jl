module MLPlots

using Reexport
@reexport using Plots
using LearnBase
using ValueHistories

export
    corrplot

include("recipes.jl")
include("loss.jl")
include("valuehistories.jl")

end # module
