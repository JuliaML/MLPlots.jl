module MLPlotsTests

using VisualRegressionTests
using FactCheck
using OnlineAI
using MLPlots

# don't let pyplot use a gui... it'll crash
# note: Agg will set gui -> :none in PyPlot
ENV["MPLBACKEND"] = "Agg"
try
    @eval import PyPlot
    info("Matplotlib version: $(PyPlot.matplotlib[:__version__])")
end
pyplot(size=(400,300), reuse=true)

# builds a testable function which saves a png to the location `fn`
# use: VisualTest(@plotfunc(plot(rand(10))), "/tmp/tmp.png")
macro plotfunc(expr)
    esc(quote
        fn -> begin
            $expr
            png(fn)
        end
    end)
end

refdir = Pkg.dir("MLPlots", "test", "refimg")

# run a visual regression test comparing the output to the saved reference png
function dotest(testname, func)
    srand(1)
    reffn = joinpath(refdir, "$testname.png")
    vtest = VisualTest(func, reffn)
    result = test_images(vtest)
    @fact success(result) --> true
end

# ---------------------------------------------------------

facts("OnlineAI") do

    # build and fit a neural net, then show it
    func = @plotfunc begin
        net = buildClassificationNet(3,1,[15,10,5])
        for i in 1:1000
            x = rand(3)
            fit!(net, x, Float64[sum(x)])
        end
        plot(net)
    end
    dotest("onlineai1", func)

    
end


# ---------------------------------------------------------

FactCheck.exitstatus()
end # module
