
"""
    basemodule(m)

Recursive version of `parentmodule`, returning the top-most module.
"""
function basemodule(m)
    m === Base && return Base
    m === Core && return Core
    parentmodule(m) === m ? m : basemodule(parentmodule(m))
end

moduleid(m::Module) = join(fullname(m), ".")
parentmoduleid(m::Module) = isnothing(parentmodule(m)) ? nothing : moduleid(parentmodule(m))

symbolid(m, s) = getfield(m, s) === m ? moduleid(m) : "$(moduleid(m)).$s"

isvalidmodule(m) = !isnothing(match(r"^[a-zA-Z].*", string(nameof(m))))

function submodules(m::Module)
    return map(s -> getfield(m, s),
               filter(names(m, all = true)) do s
                   isdefined(m, s) || return false
                   subm = getfield(m, s)
                   return subm isa Module && subm !== m && parentmodule(subm) === m
               end)
end

@memoize isfrommodule(m::Module, symbol) = isfrommodule(m, symbol, submodules(m))

@memoize function isfrommodule(m::Module, symbol, submodules)
    if any(isfrommodule(sm, symbol) for sm in submodules)
        return false
    end
    isdefined(m, symbol) || return false
    x = getfield(m, symbol)
    try
        return parentmodule(x) === m
    catch
        isconst(m, symbol) && return true
        return false
    end
end

function isvalidsymbol(m, s)
    isdefined(m, s) || return false
    #isfrommodule(m, s) || return false
    s == :include && return false
    s == :eval && return false
    return !isnothing(match(r"^[a-zA-Z].*", string(s)))
end

function packageid(m::Module)
    pkgid = Base.PkgId(m)
    if isnothing(pkgid.uuid)
        return pkgid.name
    else
        return string(pkgid.uuid)
    end
end

function pkgsrcdir(m::Module)
    m = basemodule(m)
    if m === Core
        throw(ArgumentError("Tracking Core is not supported yet!"))
    end
    if m === Base
        abspath(joinpath(Sys.BINDIR, "..", "share", "julia", "base"))
    elseif Symbol(m) === :Main
        return "Main"
    else
        pdir = Pkg.pkgdir(m)
        if isnothing(pdir)
            throw(ArgumentError("Could not find a package directory for module $m"))
        else
            joinpath(Pkg.pkgdir(m), "src")
        end
    end
end

function packagefiles(m::Module)
    dir = pkgsrcdir(m)
    return dir, filter(endswith(".jl"), readdirrecursive(dir))
end

@memoize function loadprojectfile(pkgdir)
    TOML.parsefile(joinpath(pkgdir, "Project.toml"))
end

function packageversion(m::Module, label = nothing)
    v = if m === Base || isstdlib(m)
        VERSION
    else
        if isfile(joinpath(Pkg.pkgdir(m), "Project.toml"))
            VersionNumber(loadprojectfile(Pkg.pkgdir(m))["version"])
        else
            v"0.0.0-unknown"
        end
    end
    if isnothing(label)
        v
    else
        VersionNumber(v.major, v.minor, v.patch, (label,), v.build)
    end
end

isstdlib(m) = occursin("julia/stdlib", Pkg.pkgdir(m))

function readdirrecursive(dir)
    files = String[]
    for (root, _, fs) in walkdir(dir)
        for f in fs
            push!(files, relpath(joinpath(root, f), dir))
        end
    end
    return files
end

function shortsrcpath(m::Module, file)
    pdir = pkgsrcdir(m)
    if contains(pdir, file)
        relpath(file, pdir)
    else
        parts = splitpath(file)
        i = findfirst(==("src"), parts)
        if isnothing(i)
            return file
        else
            return joinpath(parts[(i + 1):end]...)
        end
    end
end

# ## Docstrings

function getdocstrings(m, sym::Symbol)
    multidoc = getmultidoc(m, sym)
    isnothing(multidoc) && return String[], []
    docstrings = [__plain_text(multidoc.docs[sig]) for sig in multidoc.order]
    metadata = [multidoc.docs[sig].data for sig in multidoc.order]
    return docstrings, metadata
end

function getmultidoc(m::Module, symbol::Symbol)
    binding = Base.Docs.Binding(m, symbol)
    try
        docs = getproperty(m, Docs.META)
        return get(docs, binding, nothing)
    catch e
        e isa UndefVarError && return nothing
        rethrow()
    end
end

function __plain_text(d::Base.Docs.DocStr)
    if d.object isa Markdown.MD
        return Markdown.plain(d.object)
    else
        buf = IOBuffer()
        for part in d.text
            print(buf, part)
        end
        return String(take!(buf))
    end
end

function symbolkind(m::Module, symbol::Symbol)
    x = getfield(m, symbol)
    x isa DataType && return (isconcretetype(x) ? "struct" : "abstract type")
    x isa Function && return "function"
    x isa UnionAll && return (isstructtype(x) ? "struct" : "const")
    x isa Module && return "module"
    isconst(m, symbol) && return "const"
    #throw(ArgumentError("Could not detect what kind of symbol `$m.$symbol` is!"))
    return "const"
end

function bindings(m::Module)
    binds = Tuple{Module, Symbol}[]
    symbols = Set{Symbol}()
    modules = Set{Module}()
    for s in names(m, all = true, imported = true)
        startswith(string(s), "#") && continue
        if !(isdefined(m, s))
            continue
        end
        val = getproperty(m, s)
        if val isa Module
            # A submodule which we traverse to get all exported symbols
            # that may be imported into `m`'s namespace.
            # We do this AFTER adding the module's own bindings so that these
            # are correctly shadowed.
            val !== m && push!(modules, m)
            val !== m && push!(binds, (_parentmodule(m, val), s))
        else
            push!(binds, (_parentmodule(m, val), s))
            push!(symbols, s)
        end
    end

    for mdep in get_module_bindings(m)
        push!(binds, (mdep, nameof(mdep)))
        push!(modules, mdep)
    end

    foreach(modules) do subm
        subm === m && return
        for name in names(subm)
            name in symbols && continue
            if isdefined(m, name)
                push!(binds, (subm, name))
            end
            push!(symbols, name)
        end
    end

    return binds
end

_parentmodule(_::Module, f::Function) = parentmodule(f)
_parentmodule(_::Module, f::DataType) = parentmodule(f)
_parentmodule(::Module, m::Module) = parentmodule(m)
_parentmodule(m::Module, _) = m
