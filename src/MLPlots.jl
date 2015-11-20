module MLPlots

@reexport Plots

export
  corrplot,
  spy

include("src/recipes.jl")

end # module
