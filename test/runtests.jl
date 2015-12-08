using MLPlots
using Plots
using Base.Test

# write your own tests here
@test 1 == 1


# TODO: add examples/tests for each recipe

function test_onlineai()
    @eval using OnlineAI

    net = buildClassificationNet(3,1,[15,10,5])
    for i in 1:1000
        x = rand(3)
        update!(net, x, Float64[sum(x)])
    end

    plot(net)
end