
import ROCAnalysis

mid_of_vec(v::AbstractVector) = v[max(1, round(Int, length(v)/2))]

function Plots._apply_recipe(d::KW, roc::ROCAnalysis.Roc, auc = true; kw...)

    get!(d, :legend, false)
    get!(d, :xlabel, "False Positive Rate")
    get!(d, :ylabel, "True Positive Rate")
    get!(d, :linestyle, [:solid :dash])
    get!(d, :linealpha, [1.0 0.5])
    get!(d, :label, ["ROC" ""])

    x = roc.pfa
    y = 1 .- roc.pmiss

    # add fill to the diagonal
    get!(d, :fillrange, Any[0 nothing])
    get!(d, :fillalpha, 0.3)

    if auc
        auc_ann = @sprintf("AUC %1.3f", 1 - ROCAnalysis.auc(roc))
        get!(d, :annotation, (mid_of_vec(x), mid_of_vec(y), text(auc_ann, :left, :top, 9, :monospace)))
    end

    # xargs, yargs
    Any[x, 0:1], Any[y, 0:1]
end
