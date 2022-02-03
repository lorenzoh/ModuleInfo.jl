module ModuleInfo

using CodeTracking: pkgfiles, whereis
using StructArrays: StructArray


const Maybe{T} = Union{Nothing, T}


function moduleinfo(m::Module)
    return moduleinfo!(createinfostore(), m)
end

function moduleinfo(ms::AbstractVector{Module})
    info = createinfostore()
    foreach(m -> moduleinfo!(info, m), ms)
    return info
end

export moduleinfo

"""
    createinfostore()

Create a new database to hold module information.
"""
function createinfostore()
    return Dict(
        :packages => StructArray(
            package_id = String[],
            name = String[],
            basedir = String[],
        ),
        :modules => StructArray(
            module_id = String[],
            parent = Maybe{String}[],
            package_id = Maybe{String}[],  # foreign key
            instance = Module[],
        ),
        :sourcefiles => StructArray(
            package_id = String[],  # foreign key
            file = String[],
        ),
        :symbols => StructArray(
            symbol_id = String[],
            name = String[],
            public = Bool[],
            kind = String[],
            instance = Any[],
            module_id = String[],  # foreign key
        ),
        :methods => StructArray(
            method_id = String[],
            symbol_id = String[],  # foreign key
            line = Int[],
            file = String[],
            signature = Any[],
        ),
        :docstrings => StructArray(
            symbol_id = String[],  # foreign key
            docstring = String[],
        )
    )
end


function moduleinfo!(db, m::Module)
    info = pkgfiles(m)
    pkgid = string(info.id.uuid)

    # Add package entry
    push!(db[:packages], (
        package_id = pkgid,
        name = info.id.name,
        basedir = info.basedir
    ))

    # Add source files of package
    for file in info.files
        push!(db[:sourcefiles], (package_id = pkgid, file = file))
    end

    # Add module
    modulename = join(fullname(m), ".")
    push!(db[:modules], (
        module_id = modulename,
        parent = parentmodule(m) === m ? nothing : join(fullname(parentmodule(m)), "."),
        package_id = pkgid,
        instance = m,
    ))

    gathermodulesymbols!(db, m)


    return db
end


getmoduleid(m::Module) = join(fullname(m), ".")
getsymbolid(T) = join((getmoduleid(parentmodule(T)), string(nameof(T))), ".")


function gathermodulesymbols!(db, m::Module)
    moduleid = getmoduleid(m)
    for symbol in names(m, all=true)
        isdefined(m, symbol) || continue
        startswith(string(symbol), "#") && continue
        symbol == :eval && continue
        symbol == :include && continue

        isfrommodule(m, symbol) || continue

        instance = getfield(m, symbol)
        kind = symbolkind(m, symbol)
        symbol_id = m === instance ? moduleid : "$moduleid.$symbol"

        push!(db[:symbols], (
            symbol_id = symbol_id,
            name = string(symbol),
            public = Base.isexported(m, symbol),
            kind = kind,
            module_id = moduleid,
            instance,
        ))

        # Recurse into submodules
        if (kind == "module") && (parentmodule(instance) == m) && (m != instance)
            gathermodulesymbols!(db, instance)
        end
        gathermethods!(db, m, symbol)
        gatherdocstring!(db, m, symbol)
    end
end


getsymbolid(m, symbol) = join(fullname(m), ".") * "." * string(symbol)


function gatherdocstring!(db, m, symbol)
    docstrs = getdocstrings(m, symbol)
    isempty(docstrs) && return
    s = join([d.docstring for d in docstrs], "\n\n---\n\n")
    push!(db[:docstrings], (
        symbol_id = getsymbolid(m, symbol),
        docstring = s,
    ))
end


function parentmodulerec(x)
    try
        parentmodule(x) == x ? x : parentmodulerec(parentmodule(x))
    catch e
        e isa MethodError && return true
        rethrow()
    end
end

parentmodulerec(e::E) where {E<:Enum} = parentmodulerec(E)


function isfrommodule(m::Module, symbol)
    isdefined(m, symbol) || return false
    x = getfield(m, symbol)
    parentmodulerec(x) == m
end


function gathermethods!(db, m::Module, symbol::Symbol)
    modulename = join(fullname(m), ".")
    symbol_id = "$modulename.$symbol"

    x = getfield(m, symbol)
    for (i, method) in enumerate(methods(x))
        file, line = whereis(method)
        sig = join(split(string(method), ")")[1:end-1]) * ")"
        push!(db[:methods], (
            method_id = "$(symbol_id)_$i",
            symbol_id = symbol_id,
            file = file,
            line = line,
            signature = sig
        ))
    end
    return db
end


function symbolkind(m::Module, symbol::Symbol)
    x = getfield(m, symbol)
    x isa DataType && return (isconcretetype(x) ? "struct" : "abstract type")
    x isa UnionAll && return "struct"
    x isa Function && return "function"
    x isa Module && return "module"
    isconst(m, symbol) && return "const"
    return "unknown"
end


struct DocString
    m::Module
    symbol::Symbol
    docstring::String
    data
end


function getdocstrings(m::Module, symbol::Symbol)
    multidoc = getmultidoc(m, symbol)
    isnothing(multidoc) && return DocString[]
    docstrs = collect(values(multidoc.docs))
    #docstrings = [only(Base.Docs.catdoc(d.text...)) for d in docstrs]

    docstrings = []
    for d in docstrs
        text = Base.Docs.catdoc(d.text...)
        isnothing(text) && continue
        push!(docstrings, text[1])
    end
    datas = [d.data for d in docstrs]
    return [DocString(m, symbol, docstring, data)
        for (docstring, data) in zip(docstrings, datas)]
end

function getmultidoc(m::Module, symbol::Symbol)
    binding = Base.Docs.Binding(m, symbol)
    docs = getfield(m, Docs.META)
    multidoc = get(docs, binding, nothing)
end

end  # module
