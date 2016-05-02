module MLPlotsTests

using VisualRegressionTests
using FactCheck

using OnlineAI
using ROCAnalysis

using MLPlots

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

facts("CorrPlot") do
    @plottest "corrplot" begin
        M = randn(1000, 4)
        M[:,2] += 0.8M[:,1]
        M[:,3] -= 0.7M[:,1]
        corrplot(M, size=(700,700))
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


end


# ---------------------------------------------------------\

facts("ROCAnalysis") do
    @plottest "rocanalysis" begin
        plot(ROCAnalysis.roc(2+2rand(1000), -2+2rand(100000)))
    end
end

# ---------------------------------------------------------
# ---------------------------------------------------------
# ---------------------------------------------------------
# ---------------------------------------------------------

FactCheck.exitstatus()
end # module
