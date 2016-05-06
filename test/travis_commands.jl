Pkg.clone(pwd())
Pkg.build("MLPlots")

Pkg.clone("https://github.com/JuliaPlots/RecipesBase.jl.git")
Pkg.clone("https://github.com/Evizero/LearnBase.jl.git")
Pkg.clone("https://github.com/tbreloff/OnlineAI.jl.git")
Pkg.clone("https://github.com/tbreloff/QuickStructs.jl.git")

ENV["PYTHON"] = ""
Pkg.add("PyPlot")
Pkg.build("PyPlot")

Pkg.checkout("Plots")

Pkg.test("MLPlots"; coverage=false)
