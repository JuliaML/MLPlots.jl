
using Transformations

# the maps map chain transformation index to subplot index
type ChainPlot
    chain::Chain
    plt::Plot
    subplots::Vector{Subplot}
    θmap::Dict
    ∇map::Dict
    xmap::Dict
    ymap::Dict
end

function ChainPlot(chain::Chain)
end

# parameter plots
pidx = 1:2:length(t)
pvalplts = [TracePlot(length(params(t[i])), title="$(t[i])") for i=pidx]
ylabel!(pvalplts[1].plt, "Param Vals")
pgradplts = [TracePlot(length(params(t[i]))) for i=pidx]
ylabel!(pgradplts[1].plt, "Param Grads")

# nnet plots of values and gradients
valinplts = [TracePlot(input_length(t[i]), title="input", yguide="Layer Value") for i=1:1]
valoutplts = [TracePlot(output_length(t[i]), title="$(t[i])", titlepos=:left) for i=1:length(t)]
gradinplts = [TracePlot(input_length(t[i]), yguide="Layer Grad") for i=1:1]
gradoutplts = [TracePlot(output_length(t[i])) for i=1:length(t)]

# loss/accuracy plots
lossplt = TracePlot(title="Test Loss", ylim=(0,Inf))
accuracyplt = TracePlot(title="Accuracy", ylim=(0.6,1))
