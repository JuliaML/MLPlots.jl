
using OnlineAI

export
    SpikeTrains

# plot the nodes and connections of an ANN from OnlineAI
# node colors correspond to activation level
@recipe function plot(net::NeuralNet)
    :legend     --> :none
    :colorbar   --> :none
    :xlims      --> (1, length(net.layers)+1.3)
    :ylims      --> (-1, 1)
    :size       --> (800,800)
    :linealpha  --> 0.5
    :linecolor  --> :black
    :markersize --> 15

    # these will be per-series
    linetype = []
    marker_z = []
    xlist = []
    ylist = []

    # get the node data
    ns = vcat(net.layers[1].nin, [l.nout for l in net.layers])
    ys = map(n->n>1 ? linspace(0.9,-0.9,n) : zeros(1), ns)
    xs = [i*ones(n) for (i,n) in enumerate(ns)]

    # add the edges
    for i in 2:length(ns)
        x1, x2 = xs[i-1:i]
        y1, y2 = ys[i-1:i]
        pts = Tuple{Float64,Float64}[]
        for i1 in 1:length(x1)
            for i2 in 1:length(x2)
                push!(pts, (x1[i1], y1[i1]))
                push!(pts, (x2[i2], y2[i2]))
            end
        end

        push!(linetype, :path)
        push!(marker_z, nothing)
        push!(xlist, Float64[pt[1] for pt in pts])
        push!(ylist, Float64[pt[2] for pt in pts])
    end

    # add the nodes
    for i in 2:length(ns)
        push!(linetype, :scatter)
        push!(marker_z, net.layers[i-1].a)
        push!(xlist, xs[i])
        push!(ylist, ys[i])
    end

    # set the linetype and marker_z args using row-vectors
    :linetype --> reshape(linetype, 1, length(linetype)), :force
    :marker_z --> reshape(marker_z, 1, length(marker_z)), :force

    # return the args
    xlist, ylist
end

# -------------------------------------------------------

# TODO: should this object should hold the data, and make a recipe on it??

type SpikeTrains
    n::Int
    plt::Plot
end

function SpikeTrains(n::Integer; kw...)
    plt = plot(n; leg=false, yticks=nothing, kw...)
    SpikeTrains(n, plt)
end

const _halfheight = 0.4
function Base.push!(spiketrains::SpikeTrains, idx::Integer, t::Real)
    append!(spiketrains.plt, idx, Float64[NaN, t, t],
            Float64[NaN, idx + _halfheight, idx - _halfheight])
    spiketrains
end
function Base.push!{T<:Real}(spiketrains::SpikeTrains, ts::AbstractVector{T})
    for i in 1:length(ts)
        push!(spiketrains, i, ts[i])
    end
    spiketrains
end
