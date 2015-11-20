module MLPlots

using Reexport
@reexport using Plots

export
  corrplot

include("recipes.jl")

end # module
