
import ROCAnalysis

function Plots._apply_recipe(d::Dict, roc::ROCAnalysis.Roc; kw...)

    get!(d, :legend, false)
    get!(d, :xlabel, "False Positive Rate")
    get!(d, :ylabel, "True Positive Rate")
    get!(d, :linestyle, [:solid :dash])
    get!(d, :linealpha, [1.0 0.5])

    auc_ann = @sprintf("AUC %1.3f", 1 - ROCAnalysis.auc(roc))
    get!(d, :annotation, (1, 0, text(auc_ann, :right, :bottom, 12, :monospace)))

    # xargs, yargs
    Any[roc.pfa, 0:1], Any[1 .- roc.pmiss, 0:1]    
end
