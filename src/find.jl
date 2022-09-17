
getpackages(I::PackageIndex; kwargs...) = filterview(filterfields(kwargs), I.packages)
getmodules(I::PackageIndex; kwargs...) = filterview(filterfields(kwargs), I.modules)
getfiles(I::PackageIndex; kwargs...) = filterview(filterfields(kwargs), I.modules)
getsymbols(I::PackageIndex; kwargs...) = filterview(filterfields(kwargs), I.symbols)
getmethods(I::PackageIndex; kwargs...) = filterview(filterfields(kwargs), I.methods)
getdocstrings(I::PackageIndex; kwargs...) = filterview(filterfields(kwargs), I.docstrings)

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

getpackage(I::PackageIndex, id::String) = I.data.packages[I.index.packages[id]]
getpackage(I::PackageIndex, info::ModuleInfo_) = getpackage(I, info.package_id)
getpackage(I::PackageIndex, info::AbstractInfo) = getpackage(I, getmodule(I, info))

getmodule(I::PackageIndex, id) = I.data.modules[I.index.modules[id]]
getmodule(I::PackageIndex, info::SymbolInfo) = getmodule(I, info.module_id)
getsymbol(I::PackageIndex, info::BindingInfo) = getentry(I, :symbols, info.symbol_id)

getbinding(I::PackageIndex, id::String) = getentry(I, :bindings, id)

function getentry(I::PackageIndex, store::Symbol, id::String)
    @assert store in keys(INFOS)
    index = getproperty(I.index, store)
    haskey(index, id) || return nothing
    return getproperty(I.data, store)[index[id]]
end

"""
    resolvebinding(I::PackageIndex, modulename, bindingname)
    resolvebinding(I::PackageIndex, modulenames, bindingname)

Search the package index for valid bindings for `bindingname` in the scope of one or more
`modulename`s, returning a list of [`BindingInfo`](#)s.

## Examples

{cell}
```julia
using ModuleInfo, Pkg

pkgindex = PackageIndex([ModuleInfo, Pkg])

resolvebinding(pkgindex, ["ModuleInfo"], "resolvebinding")
```

All kinds of module accesses should resolve correctly if the
relevant packages are indexed:

{cell}
```julia
resolvebinding(pkgindex, ["ModuleInfo"], "ModuleInfo.resolvebinding")
```

This includes dependency packages:

{cell}
```julia
resolvebinding(pkgindex, ["ModuleInfo"], "ModuleInfo.Pkg.pkgdir")
```

"""
function resolvebinding(I::PackageIndex, m::String, b::String)
    ret = _resolvebinding(I, m, split(b, '.'))
    binding = isnothing(ret) ? nothing : ModuleInfo.getbinding(I, ret)
end

function resolvebinding(I::PackageIndex, ms::Vector{String}, b::String)
    filter(!isnothing, map(m -> resolvebinding(I, m, b), ms))
end

function _resolvebinding(I::PackageIndex, m::String, parts)
    isempty(parts) && return nothing
    if m == parts[1]
        return _resolvebinding(I, m, parts[2:end])
    end

    if length(parts) == 1
        return "$m.$(only(parts))"
    else
        bi = ModuleInfo.getbinding(I, "$m.$(parts[1])")
        if !isnothing(bi)
            return _resolvebinding(I, bi.symbol_id, parts[2:end])
        else
            return nothing
        end
    end
end
