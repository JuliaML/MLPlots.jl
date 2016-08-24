module MLPlotsTests

using VisualRegressionTests
using FactCheck

using LearnBase
using OnlineAI
import ROCAnalysis
import ValueHistories

using MLPlots, Plots

# don't let pyplot use a gui... it'll crash
# note: Agg will set gui -> :none in PyPlot
ENV["MPLBACKEND"] = "Agg"
try
    @eval import PyPlot
    info("Matplotlib version: $(PyPlot.matplotlib[:__version__])")
end
pyplot(size=(400,300), reuse=true)


refdir = Pkg.dir("MLPlots", "test", "refimg")

# run a visual regression test comparing the output to the saved reference png
function dotest(testname, func)
    srand(1)
    reffn = joinpath(refdir, "$testname.png")
    vtest = VisualTest(func, reffn)
    result = test_images(vtest)
    @fact success(result) --> true
end

# builds a testable function which saves a png to the location `fn`
# use: VisualTest(@plotfunc(plot(rand(10))), "/tmp/tmp.png")
macro plottest(testname, expr)
    esc(quote
        dotest(string($testname), fn -> begin
            $expr
            png(fn)
        end)
    end)
end

# ---------------------------------------------------------


facts("LearnBase") do
    with(size=(300,300), guidefont=font(9), tickfont=font(7)) do
        @plottest "learnbase1" begin
            plot(LossFunctions.HingeLoss())
        end
        @plottest "learnbase2" begin
            plot([ZeroOneLoss(), L1HingeLoss(), L2HingeLoss(), LogitMarginLoss()])
        end
        @plottest "learnbase3" begin
            subplot([ZeroOneLoss(), L1HingeLoss(), L2HingeLoss(), LogitMarginLoss()], size=(400,400))
        end
        @plottest "learnbase4" begin
            plot(LossFunctions.L2DistLoss())
        end
        @plottest "learnbase5" begin
            plot([L2DistLoss(), L1DistLoss(), EpsilonInsLoss(.4), LogitDistLoss()])
        end
        @plottest "learnbase6" begin
            subplot([L2DistLoss(), L1DistLoss(), EpsilonInsLoss(.4), LogitDistLoss()], size=(400,400))
        end
    end
end

# ---------------------------------------------------------

facts("CorrPlot") do
    @plottest "corrplot" begin
        M = randn(1000, 4)
        M[:,2] += 0.8M[:,1]
        M[:,3] -= 0.7M[:,1]
        corrplot(M, size=(500,500))
    end
end

# ---------------------------------------------------------

facts("OnlineAI") do

    # build and fit a neural net, then show it
    @plottest "onlineai1" begin
        net = buildClassificationNet(3,1,[15,10,5])
        for i in 1:1000
            x = rand(3)
            fit!(net, x, Float64[sum(x)])
        end
        plot(net)
    end

    @plottest "onlineai2" begin
        n = 20
        spikes = SpikeTrains(n, title = "Spike Trains", color = :darkblue)
        for t=1:100, i=1:n
            if rand() < 0.1
                push!(spikes, i, t)
            end
        end
        spikes.plt
    end
end


# ---------------------------------------------------------\

facts("ROCAnalysis") do
    @plottest "rocanalysis" begin
        plot(ROCAnalysis.roc(2+2randn(1000), -2+2randn(100000)))
    end
end

# ---------------------------------------------------------

facts("ValueHistories") do
    @plottest "valuehistories1" begin
        history = ValueHistories.DynMultivalueHistory()
        for i=1:100
            x = 0.1i
            push!(history, :a, x, sin(x))
            push!(history, :wrongtype, x, "$(sin(x))")
            if i % 10 == 0
                push!(history, :b, x, cos(x))
            end
        end
        plot(history)
    end

    @plottest "valuehistories2" begin
        history = ValueHistories.QueueUnivalueHistory(Int)
        for i = 1:100
            push!(history, i, 2i)
        end
        plot(history)
    end

    @plottest "valuehistories3" begin
        history = ValueHistories.VectorUnivalueHistory(Int)
        for i = 1:100
            push!(history, i, 100-i)
        end
        plot(history)
    end
end

# ---------------------------------------------------------
# ---------------------------------------------------------
# ---------------------------------------------------------

FactCheck.exitstatus()
end # module
