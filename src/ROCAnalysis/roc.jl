using Plots
using ROCAnalysis

function Plots._apply_recipe(d::Dict, roc::ROCAnalysis.Roc; kw...)

    get!(d, :legend, false)
    get!(d, :xlims, (0,1))
    get!(d, :ylims, (0,1))
    get!(d, :xlabel, "False Positive Rate")
    get!(d, :ylabel, "True Positive Rate")

    xargs = []
    yargs = []
    linealpha = Float64[]
    linestyle = Symbol[]

    push!(xargs, roc.pfa) # probability of false alarm, false positive rate, 1 - specificity
    # roc.pmiss (probability of miss, 1 - true positive rate, 1 - sensitivity)
    push!(yargs, 1 .- roc.pmiss) # true positive rate, sensitivity
    push!(linealpha, 1.0)
    push!(linestyle, :solid)

    push!(xargs, [0, 1])
    push!(yargs, [0, 1])
    push!(linealpha, 0.5)
    push!(linestyle, :dash)

    d[:linealpha] = reshape(linealpha, 1, length(linealpha))
    d[:linestyle] = reshape(linestyle, 1, length(linestyle))

    # if plt.n == 0
    #    AUC = round(1 - ROCAnalysis.auc(roc), 4)
    #    get!(d, :annotation, (0.9, 0.05, text("AUC $(AUC)", :center, 10, :monospace)))
    # end

    xargs, yargs
end
