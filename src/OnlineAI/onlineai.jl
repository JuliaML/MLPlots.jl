
using OnlineAI

export
    SpikeTrains

# plot the nodes and connections of an ANN from OnlineAI
# node colors correspond to activation level
function Plots._apply_recipe(d::Dict, net::NeuralNet; kw...)
    
    # set the args that apply to all series
    get!(d, :legend, false)
    get!(d, :xlims, (1, length(net.layers)+1.3))
    get!(d, :ylims, (-1, 1))
    get!(d, :size, (800,800))
    get!(d, :linealpha, 0.5)
    get!(d, :linecolor, :black)
    get!(d, :markersize, 20)
    get!(d, :markercolor, :redsblues)

    # these will be per-series
    linetype = []
    zcolor = []
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
        push!(zcolor, nothing)
        push!(xlist, Float64[pt[1] for pt in pts])
        push!(ylist, Float64[pt[2] for pt in pts])
    end

    # add the nodes
    for i in 2:length(ns)
        push!(linetype, :scatter)
        push!(zcolor, net.layers[i-1].a)
        push!(xlist, xs[i])
        push!(ylist, ys[i])
    end

    # set the linetype and zcolor args using row-vectors
    d[:linetype] = reshape(linetype, 1, length(linetype))
    d[:zcolor] = reshape(zcolor, 1, length(zcolor))

    # return the args
    xlist, ylist
end

# -------------------------------------------------------

type SpikeTrains
    n::Int
    plt::Plot
end

function SpikeTrains(n::Integer; kw...)
    d = Dict(kw)
    sz = get(d, :ms) do
        h = get(d, :size, default(:size))[2]
        max(1, round(Int, 0.3 * (h-100) / n))
    end
    plt = scatter(n; markersize=sz, markershape=:spike, legend=false, yticks=nothing, d...)
    SpikeTrains(n, plt)
end

function Base.push!(spiketrains::SpikeTrains, idx::Integer, t::Real)
    push!(spiketrains.plt, idx, t, idx)
    spiketrains
end
function Base.push!{T<:Real}(spiketrains::SpikeTrains, ts::AbstractVector{T})
    for i in 1:length(ts)
        push!(spiketrains, i, ts[i])
    end
    spiketrains
end

