
using Transformations

export
    ChainPlot

# -------------------------------------------------------------------------

#=
A ChainPlot is a bunch of TracePlots that are updated with the param/input/output
values and gradients from a Transformations.Chain.  An example:

using MLPlots, Transformations

# build a neural net
nn = nnet(2,3,[2,10],:softplus)

# build the ChainPlot.  attributes pass through to the plot
cp = ChainPlot(nn, size=(1000,1000))

for i=1:20
    # make some random updates to the Chain
    transform!(nn, rand(2))
    grad!(nn, rand(3))

    # update the ChainPlot and display it
    update!(cp)
    gui()
=#

# the maps map chain transformation index to subplot index
type ChainPlot
    chain::Chain
    plt::Plot
    nt::Int # number of transformations
    np::Int # number of params
    lastx::Float64
    θtps::Vector{TracePlot}
    ∇tps::Vector{TracePlot}
    ytps::Vector{TracePlot}
    dytps::Vector{TracePlot}
end

function add_traceplots(plt, valtps, gradtps, n, idxbase, i, idxdiff, title, add_yguide, kw)
    push!(valtps, TracePlot(n; sp=plt[idxbase+i], title=title, yguide=(add_yguide ? "Value" : ""), kw...))
    push!(gradtps, TracePlot(n; sp=plt[idxbase+i+idxdiff], yguide=(add_yguide ? "Grad" : ""), kw...))
end

function ChainPlot(chain::Chain; kw...)
    nparams = count(t->length(params(t))>0, chain.ts)
    n = length(chain.ts)

    plt = plot(layout = @layout([grid(2,nparams)
                                 grid(2,n+1)]),
                leg=false, titlefont=font(10))

    θtps = TracePlot[]
    ∇tps = TracePlot[]
    ytps = TracePlot[]
    dytps = TracePlot[]
    pidx = 1
    for (i,t) in enumerate(chain.ts)
        np = length(params(t))
        if np > 0
            add_traceplots(plt, θtps, ∇tps, np, 0, pidx, nparams, string(t), i==1, kw)
            pidx += 1
        end

        if i == 1
            nin = input_length(t)
            add_traceplots(plt, ytps, dytps, nin, 2nparams, i, n, "Input", true, kw)
        end

        nout = output_length(t)
        add_traceplots(plt, ytps, dytps, nout, 2nparams+1, i, n, string(t), false, kw)
    end

    ChainPlot(chain, plt, n, nparams, 0.0, θtps, ∇tps, ytps, dytps)
end

function LearnBase.update!(cp::ChainPlot, x = cp.lastx+1)
    pidx = 1
    for (i,t) in enumerate(cp.chain.ts)
        np = length(params(t))

        if np > 0
            push!(cp.θtps[pidx], x, params(t))
            push!(cp.∇tps[pidx], x, grad(t))
            pidx += 1
        end
        idxbase = 2 * cp.np + 1
        if i == 1
            push!(cp.ytps[1], x, input_value(t))
            push!(cp.dytps[1], x, input_grad(t))
        end
        push!(cp.ytps[i+1], x, output_value(t))
        push!(cp.dytps[i+1], x, output_grad(t))
    end
    cp.lastx = x
    return
end
