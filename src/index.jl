
"""

    addentry!(pkgindex, info; overwrite) -> Bool

Return whether an entry was added/modified. If `overwrite = true`,
modifies existing entries, returning `true`.

```julia
addentry!(pkgindex, PackageInfo(...))
```
"""
function addentry!(pkgindex::PackageIndex, info; overwrite = false)
    k, id = getkey(info), getid(info)
    if exists(pkgindex, info)
        if overwrite
            pkgindex.data[k][pkgindex.index[k][id]] = info
            return true
        else
            return false
        end
    else
        push!(pkgindex.data[k], info)
        pkgindex.index[k][id] = length(pkgindex.data[k])
    end
    return true
end

exists(pkgindex, info) = haskey(pkgindex.index[getkey(info)], getid(info))

function indexpackage!(pkgindex::PackageIndex, m::Module; overwrite = false, recurse = 0,
                       verbose = false, cache = NoCache(), packages = nothing,
                       visited = Set{String}(), pkgtags = Dict{String, String}())
    m = basemodule(m)
    id = packageid(m)
    dir, files = packagefiles(m)
    pkgdir = joinpath(dir, "..")
    name = moduleid(m)
    depms = getdepmodules(m)
    dependencies = map(m_ -> "$m_@$(get(pkgtags, string(m_), packageversion(m_)))", depms)
    info = PackageInfo(name, id, get(pkgtags, name, string(packageversion(m))), pkgdir,
                       dependencies)

    # TODO: fix overwrite
    if haskey(pkgindex.index.packages, getid(info)) || name in visited
        return
    end

    if (isnothing(packages) || (name in packages))
        if iscached(cache, info)
            data = readfromcache(cache, info)
            pkgindex = extend!(pkgindex, data)
        else
            addentry!(pkgindex, info; overwrite)
            verbose && print("\e[2mIndexing\e[22m \e[3m$m\e[23m\e[2m...\e[22m")
            for file in files
                if isfile(joinpath(dir, file))
                    addentry!(pkgindex, FileInfo(getid(info), file); overwrite)
                end
            end
            indexmodule!(pkgindex, getid(info), m; overwrite, verbose)
            verbose && print("\e[2K\r")
        end
    end
    push!(visited, name)

    # Descend into loaded submodules where available
    if recurse > 0
        foreach(sort(getdepmodules(m), by = fullname)) do m_
            indexpackage!(pkgindex, m_; overwrite = false, recurse = recurse - 1, verbose,
                          cache,
                          packages, visited)
        end
    end

    return pkgindex
end

function indexmodule!(pkgindex::PackageIndex, pkgid::String, m::Module; overwrite = false,
                      verbose = false)
    if addentry!(pkgindex, ModuleInfo_(moduleid(m), parentmoduleid(m), pkgid); overwrite)
        for subm in submodules(m)
            isvalidmodule(subm) && indexmodule!(pkgindex, pkgid, subm; overwrite, verbose)
        end

        # TODO: store somewhere identifiers that are available, but not from this module
        for symbol in names(m, all = true, imported = true)
            indexsymbol!(pkgindex, m, symbol; overwrite)

            # If the symbol is exported automatically, it will not show up in `names`
            # so we need to add bindings to all modules that use this module.
            # This means packages that depend on it
        end

        for (parentm, symbol) in bindings(m)
            symbol_id = string(parentm) == string(symbol) ? string(symbol) :
                        "$parentm.$symbol"
            addentry!(pkgindex,
                      BindingInfo(symbolid(m, symbol),
                                  string(symbol),
                                  moduleid(m),
                                  symbol_id,
                                  Base.isexported(m, symbol)); overwrite)
        end
    end
end

function indexsymbol!(pkgindex::PackageIndex, m::Module, symbol::Symbol; overwrite = false)
    isvalidsymbol(m, symbol) && isfrommodule(m, symbol) || return

    instance = getfield(m, symbol)
    kind = symbolkind(m, symbol)
    sid = symbolid(m, symbol)

    parentm = kind == "const" ? m : parentmodule(instance)
    info = SymbolInfo(sid,
                      string(symbol),
                      moduleid(m),
                      parentm === m ? nothing : moduleid(parentm),
                      Symbol(kind),
                      Base.isexported(parentm, symbol))

    if addentry!(pkgindex, info; overwrite) #&& parentm === m
        sid, m = if kind != "const" && parentm !== m && isdefined(parentm, symbol)
            symbolid(parentm, symbol), parentm
        else
            sid, m
        end
        for m in methods(instance)
            m.module === Core && continue
            # TOOD: what if single line defines multiple methods?
            m.file == :string && continue
            file = shortsrcpath(m.module, string(m.file))
            addentry!(pkgindex,
                      MethodInfo(sid, moduleid(m.module), file, m.line, "(::Signature)"))
        end

        docstrs, metas = getdocstrings(m, symbol)
        for (docstr, meta) in zip(docstrs, metas)
            file = shortsrcpath(meta[:module], meta[:path])
            addentry!(pkgindex,
                      DocstringInfo(sid, moduleid(meta[:module]), docstr, file,
                                    meta[:linenumber]))
        end
    end
end
