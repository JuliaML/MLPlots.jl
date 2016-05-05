
"Correlation scatter matrix"
function corrplot{T<:Real,S<:Real}(mat::Plots.AMat{T}, corrmat::Plots.AMat{S} = cor(mat);
                                   colors = :redsblues,
                                   labels = nothing, kw...)
    m = size(mat,2)
    centers = Float64[mean(extrema(mat[:,i])) for i in 1:m]

    # might be a mistake?
    @assert m <= 20
    @assert size(corrmat) == (m,m)

    # create a subplot grid, and a gradient from -1 to 1
    p = subplot(m^2; n=m^2, leg=false, grid=false, kw...)
    cgrad = ColorGradient(colors, [-1,1])

    # make all the plots
    for i in 1:m
        for j in 1:m
            idx = p.layout[i,j]
            plt = p.plts[idx]
            if i==j
                # histogram on diagonal
                histogram!(plt, mat[:,i], c=:black)
                i > 1 && plot!(plt, yticks = :none)
            elseif i < j
                # annotate correlation value in upper triangle
                mi, mj = centers[i], centers[j]
                plot!(plt, [mj], [mi],
                           ann = (mj, mi, text(@sprintf("Corr:\n%0.3f", corrmat[i,j]), 15)),
                           yticks=:none)
            else
                # scatter plots in lower triangle; color determined by correlation
                c = getColorZ(cgrad, corrmat[i,j])
                scatter!(plt, mat[:,j], mat[:,i], lc=:black, m=(4,0.4,c,stroke(0)), smooth=true)
            end

            if labels != nothing && length(labels) >= m
                i == m && xlabel!(plt, string(labels[j]))
                j == 1 && ylabel!(plt, string(labels[i]))
            end
        end
    end

    # link the axes
    subplot!(p, link = (r,c) -> (true, r!=c))
end
