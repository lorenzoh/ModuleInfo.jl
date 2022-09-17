
struct PackageIndex{TData, TIndex}
    data::TData
    index::TIndex
end

PackageIndex() = PackageIndex(newdata(), newindex())
function PackageIndex(ms::Vector{Module}; cache = true, kwargs...)
    cache = cache isa Bool ? (cache ? CACHE[] : NoCache()) : cache
    I = PackageIndex()
    visited = Set{String}()
    foreach(m -> indexpackage!(I, m; cache, visited, kwargs...), ms)
    writecache(cache, I)
    return I
end
PackageIndex(m::Module; kwargs...) = PackageIndex([m]; kwargs...)
PackageIndex(data::NamedTuple) = PackageIndex(data, __createindex(data))
function Base.show(io::IO, I::PackageIndex)
    print(io, "PackageIndex(")
    for (i, (k, entries)) in enumerate(pairs(I.data))
        n = length(entries)
        printstyled(io, n, bold = true)
        print(io, " ")
        name = n == 1 ? string(k)[1:(end - 1)] : k
        print(io, "\e[2m", name, "\e[22m")
        i < length(I.data) && print(io, ", ")
    end
    print(io, ")")
end

function extend!(I::PackageIndex, data::NamedTuple; overwrite = false)
    for x in Iterators.flatten(values(data))
        addentry!(I, x; overwrite)
    end
    return I
end

function Base.getproperty(I::PackageIndex, k::Symbol)
    data = getfield(I, :data)
    if k in keys(data)
        return (data[k])
    else
        return getfield(I, k)
    end
end

Base.propertynames(I::PackageIndex) = keys(getfield(I, :data))

function index!(I::PackageIndex, m)
    moduleinfo!(I.data, m)
    return I
end

function newdata()
    return (packages = StructArray(PackageInfo[]),
            modules = StructArray(ModuleInfo_[]),
            files = StructArray(FileInfo[]),
            symbols = StructArray(SymbolInfo[]),
            methods = StructArray(MethodInfo[]),
            docstrings = StructArray(DocstringInfo[]),
            bindings = StructArray(BindingInfo[]))
end

function newindex()
    return (packages = Dict{String, Int}(),
            modules = Dict{String, Int}(),
            files = Dict{String, Int}(),
            symbols = Dict{String, Int}(),
            methods = Dict{String, Int}(),
            docstrings = Dict{String, Int}(),
            bindings = Dict{String, Int}())
end

function __createindex(data)
    NamedTuple(k => Dict(getid(x) => i for (i, x) in enumerate(xs))
               for (k, xs) in pairs(data))
end
