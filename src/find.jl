
getpackages(pkgindex; kwargs...) = getentries(pkgindex, :packages; kwargs...)
getmodules(pkgindex; kwargs...) = getentries(pkgindex, :modules; kwargs...)
getfiles(pkgindex; kwargs...) = getentries(pkgindex, :files; kwargs...)
getsymbols(pkgindex; kwargs...) = getentries(pkgindex, :symbols; kwargs...)
getdocstrings(pkgindex; kwargs...) = getentries(pkgindex, :docstrings; kwargs...)
getmethods(pkgindex; kwargs...) = getentries(pkgindex, :methods; kwargs...)

function getentries(pkgindex::PackageIndex, store::Symbol; kwargs...)
    filterview(filterfields(kwargs), getproperty(pkgindex, store))
end

function filterview(f, xs)
    I = map(f, xs)
    view(xs, I)
end

function filterfields(filters, obj)
    for (k, v) in filters
        getproperty(obj, k) == v || return false
    end
    return true
end
filterfields(filters) = Base.Fix1(filterfields, filters)

function getpackage(pkgindex::PackageIndex, id::String)
    pkgindex.data.packages[pkgindex.index.packages[id]]
end
function getpackage(pkgindex::PackageIndex, info::ModuleInfo_)
    getpackage(pkgindex, info.package_id)
end
function getpackage(pkgindex::PackageIndex, info::AbstractInfo)
    getpackage(pkgindex, getmodule(pkgindex, info))
end

getmodule(pkgindex::PackageIndex, id) = pkgindex.data.modules[pkgindex.index.modules[id]]
getmodule(pkgindex::PackageIndex, info::SymbolInfo) = getmodule(pkgindex, info.module_id)
function getsymbol(pkgindex::PackageIndex, info::BindingInfo)
    getentry(pkgindex, :symbols, info.symbol_id)
end

getbinding(pkgindex::PackageIndex, id::String) = getentry(pkgindex, :bindings, id)

function getentry(pkgindex::PackageIndex, store::Symbol, id::String)
    @assert store in keys(INFOS)
    index = getproperty(pkgindex.index, store)
    haskey(index, id) || return nothing
    return getproperty(pkgindex.data, store)[index[id]]
end

"""
    resolvebinding(pkgindex::PackageIndex, modulename, bindingname)
    resolvebinding(pkgindex::PackageIndex, modulenames, bindingname)

Search the package index for valid bindings for `bindingname` in the scope of one or more
`modulename`s, returning a list of [`BindingInfo`](#)s.

## Examples

{cell}
```julia
using ModuleInfo, Pkg
import ModuleInfo: resolvebinding

pkgindex = PackageIndex([ModuleInfo, Pkg])

resolvebinding(pkgindex, ["ModuleInfo"], "resolvebinding")
```

All kinds of module accesses should resolve correctly if the
relevant packages are indexed:

{cell}
```julia
resolvebinding(pkgindex, ["ModuleInfo"], "ModuleInfo.resolvebinding")
```

This includes dependency packages, if they are indexed:

{cell}
```julia
resolvebinding(pkgindex, ["ModuleInfo"], "ModuleInfo.Pkg.status")
```

"""
function resolvebinding(pkgindex::PackageIndex, m::String, b::String)
    ret = _resolvebinding(pkgindex, m, split(b, '.'))
    binding = isnothing(ret) ? nothing : ModuleInfo.getbinding(pkgindex, ret)
end

function resolvebinding(pkgindex::PackageIndex, ms::Vector{String}, b::String)
    filter(!isnothing, map(m -> resolvebinding(pkgindex, m, b), ms))
end

function _resolvebinding(pkgindex::PackageIndex, m::String, parts)
    isempty(parts) && return nothing
    if m == parts[1]
        return _resolvebinding(pkgindex, m, parts[2:end])
    end

    if length(parts) == 1
        return "$m.$(only(parts))"
    else
        bi = ModuleInfo.getbinding(pkgindex, "$m.$(parts[1])")
        if !isnothing(bi)
            return _resolvebinding(pkgindex, bi.symbol_id, parts[2:end])
        else
            return nothing
        end
    end
end
