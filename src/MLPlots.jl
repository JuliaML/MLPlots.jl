module MLPlots

using Reexport
@reexport using Plots
using Requires

export
    corrplot

include("recipes.jl")
@require LearnBase include("loss.jl")
@require ValueHistories include("valuehistories.jl")

end # module
