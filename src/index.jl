
"""

    addentry!(I, info; overwrite) -> Bool

Return whether an entry was added/modified. If `overwrite = true`,
modifies existing entries, returning `true`.

```julia
addentry!(I, PackageInfo(...))
```
"""
function addentry!(I::PackageIndex, info; overwrite = false)
    k, id = getkey(info), getid(info)
    if exists(I, info)
        if overwrite
            I.data[k][I.index[k][id]] = info
            return true
        else
            return false
        end
    else
        push!(I.data[k], info)
        I.index[k][id] = length(I.data[k])
    end
    return true
end

exists(I, info) = haskey(I.index[getkey(info)], getid(info))

function indexpackage!(I::PackageIndex, m::Module; overwrite = false, recurse = 0,
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
    if haskey(I.index.packages, getid(info)) || name in visited
        return
    end

    if (isnothing(packages) || (name in packages))
        if iscached(cache, info)
            data = readfromcache(cache, info)
            I = extend!(I, data)
        else
            addentry!(I, info; overwrite)
            verbose && print("\e[2mIndexing\e[22m \e[3m$m\e[23m\e[2m...\e[22m")
            for file in files
                if isfile(joinpath(dir, file))
                    addentry!(I, FileInfo(getid(info), file); overwrite)
                end
            end
            indexmodule!(I, getid(info), m; overwrite, verbose)
            verbose && print("\e[2K\r")
        end
    end
    push!(visited, name)

    # Descend into loaded submodules where available
    if recurse > 0
        foreach(sort(getdepmodules(m), by = fullname)) do m_
            indexpackage!(I, m_; overwrite = false, recurse = recurse - 1, verbose, cache,
                          packages, visited)
        end
    end

    return I
end

function indexmodule!(I::PackageIndex, pkgid::String, m::Module; overwrite = false,
                      verbose = false)
    if addentry!(I, ModuleInfo_(moduleid(m), parentmoduleid(m), pkgid); overwrite)
        for subm in submodules(m)
            isvalidmodule(subm) && indexmodule!(I, pkgid, subm; overwrite, verbose)
        end

        # TODO: store somewhere identifiers that are available, but not from this module
        for symbol in names(m, all = true, imported = true)
            indexsymbol!(I, m, symbol; overwrite)

            # If the symbol is exported automatically, it will not show up in `names`
            # so we need to add bindings to all modules that use this module.
            # This means packages that depend on it
        end

        for (parentm, symbol) in bindings(m)
            symbol_id = string(parentm) == string(symbol) ? string(symbol) :
                        "$parentm.$symbol"
            addentry!(I,
                      BindingInfo(symbolid(m, symbol),
                                  string(symbol),
                                  moduleid(m),
                                  symbol_id,
                                  Base.isexported(m, symbol)); overwrite)
        end
    end
end

function indexsymbol!(I::PackageIndex, m::Module, symbol::Symbol; overwrite = false)
    isvalidsymbol(m, symbol) && isfrommodule(m, symbol) || return

    instance = getfield(m, symbol)
    kind = symbolkind(m, symbol)
    sid = symbolid(m, symbol)

    parentm = kind == "const" ? m : parentmodule(instance)
    info = SymbolInfo(sid,
                      string(symbol),
                      moduleid(m),
                      parentm === m ? nothing : moduleid(parentm),
                      Symbol(kind))

    if addentry!(I, info; overwrite) #&& parentm === m
        sid, m = if kind != "const" && parentm !== m && isdefined(parentm, symbol)
            symbolid(parentm, symbol), parentm
        else
            sid, m
        end
        for m in methods(instance)
            m.module === Core && continue
            # TOOD: what if single line defines multiple methods?
            file = shortsrcpath(m.module, string(m.file))
            addentry!(I, MethodInfo(sid, moduleid(m.module), file, m.line, "(::Signature)"))
        end

        docstrs, metas = getdocstrings(m, symbol)
        for (docstr, meta) in zip(docstrs, metas)
            file = shortsrcpath(meta[:module], meta[:path])
            addentry!(I,
                      DocstringInfo(sid, moduleid(meta[:module]), docstr, file,
                                    meta[:linenumber]))
        end
    end
end
