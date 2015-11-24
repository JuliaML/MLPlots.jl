using ValueHistories

_is_plotable_history(::UnivalueHistory) = false
_is_plotable_history{I,V<:Real}(::QueueUnivalueHistory{I,V}) = true
_is_plotable_history{I,V<:Real}(::VectorUnivalueHistory{I,V}) = true

function _filter_plotable_histories(h::DynMultivalueHistory)
    filtered = Dict{Symbol,UnivalueHistory}()
    for (k, v) in h.storage
        if _is_plotable_history(v)
            filtered[k] = v
        end
    end
    filtered
end

function Plots.plot{I,V<:Real}(h::VectorUnivalueHistory{I,V}; marker = (:ellipse, 1.5), leg = false, kw...)
    plot(get(h)...; marker = marker, leg = leg, kw...)
end

function Plots.plot!{I,V<:Real}(plt::Plots.Plot, h::VectorUnivalueHistory{I,V}; marker = (:ellipse, 1.5), kw...)
    plot!(plt, get(h)...; marker = marker, kw...)
end

function Plots.plot{I,V<:Real}(h::QueueUnivalueHistory{I,V}; marker = (:ellipse, 1.5), leg = false, kw...)
    plot(get(h)...; marker = marker, leg = leg, kw...)
end

function Plots.plot!{I,V<:Real}(plt::Plots.Plot, h::QueueUnivalueHistory{I,V}; marker = (:ellipse, 1.5), kw...)
    plot!(plt, get(h)...; marker = marker, kw...)
end

function Plots.plot(h::DynMultivalueHistory; title = "Multivalue History", leg = true, kw...)
    h_vec = [(k, v) for (k, v) in _filter_plotable_histories(h)]
    if length(h_vec) > 0
        plt = plot(h_vec[1][2]; label = string(h_vec[1][1]), title = title, leg = leg, kw...)
        for i = 2:length(h_vec)
            plot!(plt, h_vec[i][2]; label = string(h_vec[i][1]))
        end
        plt
    else
        throw(ArgumentError("Can't plot an empty history, nor a history with strange types"))
    end
end

function Plots.subplot(h::DynMultivalueHistory; linkx = true, kw...)
    plts = [plot(v; title = string(k)) for (k, v) in _filter_plotable_histories(h)]
    if length(plts) > 0
        subplot(plts...; linkx = linkx, kw...)
    else
        throw(ArgumentError("Can't plot an empty history, nor a history with strange types"))
    end
end
