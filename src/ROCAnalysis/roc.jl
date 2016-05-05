
import ROCAnalysis

mid_of_vec(v::AbstractVector) = v[max(1, round(Int, length(v)/2))]

# function Plots._apply_recipe(d::KW, roc::ROCAnalysis.Roc, auc = true; kw...)

@plotrecipe (roc::ROCAnalysis, auc=true) begin
    :legend => false
    :xlabel => "False Positive Rate"
    :ylabel => "True Positive Rate"
    :linestyle => [:solid :dash]
    :linealpha => [1.0 0.5]
    :label => ["ROC" ""]

    x = roc.pfa
    y = 1 .- roc.pmiss

    # add fill to the diagonal
    :fillrange => Any[0 nothing]
    :fillalpha => 0.3

    if auc
        auc_ann = @sprintf("AUC %1.3f", 1 - ROCAnalysis.auc(roc))
        :annotation => (mid_of_vec(x), mid_of_vec(y), text(auc_ann, :left, :top, 9, :monospace))
    end

    # xargs, yargs
    Any[x, 0:1], Any[y, 0:1]
end
