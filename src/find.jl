

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
