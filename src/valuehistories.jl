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

function Plots._apply_recipe{I,V<:Real}(d::Dict, h::VectorUnivalueHistory{I,V}; kw...)
    d[:markershape] = get(d, :markershape, :ellipse)
    d[:markersize] = get(d, :markersize, 1.5)
    d[:legend] = get(d, :legend, false)
    get(h)
end

function Plots._apply_recipe{I,V<:Real}(d::Dict, h::QueueUnivalueHistory{I,V}; kw...)
    d[:markershape] = get(d, :markershape, :ellipse)
    d[:markersize] = get(d, :markersize, 1.5)
    d[:legend] = get(d, :legend, false)
    get(h)
end

function Plots._apply_recipe(d::Dict, h::DynMultivalueHistory; kw...)
    filtered = _filter_plotable_histories(h)
    k_vec = [k for (k, v) in filtered]
    v_vec = [v for (k, v) in filtered]
    if length(v_vec) > 0
        d[:markershape] = get(d, :markershape, fill(:ellipse, 1, length(v_vec)))
        d[:markersize] = get(d, :markersize, fill(1.5, 1, length(v_vec)))
        d[:title]  = get(d, :title, "Multivalue History")
        d[:legend] = get(d, :legend, true)
        d[:label]  = get(d, :label, map(string, k_vec)')
        if get(d, :n, 0) == length(v_vec)
            d[:legend] = false
            d[:title] = d[:label]
        end
        get_vec = map(get, v_vec)
        [x for (x, y) in get_vec], [y for (x, y) in get_vec]
    else
        throw(ArgumentError("Can't plot an empty history, nor a history with strange types"))
    end
end
