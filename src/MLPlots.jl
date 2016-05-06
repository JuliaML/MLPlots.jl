module MLPlots

using Reexport
@reexport using Plots
using RecipesBase
using Requires

export
    corrplot

include("recipes.jl")
@require LearnBase        include("LearnBase/LearnBase.jl")
@require ValueHistories   include("ValueHistories/ValueHistories.jl")
@require OnlineAI         include("OnlineAI/onlineai.jl")
@require ROCAnalysis      include("ROCAnalysis/roc.jl")

end # module
