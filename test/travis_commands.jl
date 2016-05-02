Pkg.clone(pwd())
Pkg.build("MLPlots")

Pkg.clone("https://github.com/Evizero/LearnBase.jl.git")
Pkg.clone("https://github.com/tbreloff/OnlineAI.jl.git")

Pkg.test("MLPlots"; coverage=false)
