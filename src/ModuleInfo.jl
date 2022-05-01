module ModuleInfo

using CodeTracking: pkgfiles, whereis
using StructArrays: StructArray
using InlineTest


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

    # If `m` is a top-level module
    if parentmodulerec(m) == m
        # Add package entry
        push!(db[:packages], (
            package_id = pkgid,
            name = info.id.name,
            basedir = info.basedir
        ))

    # Add source files of package
        for file in info.files
            if isfile(joinpath(pkgdir(m), file))
                push!(db[:sourcefiles], (package_id = pkgid, file = file))
            end
        end
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
    childmodules = Module[]

    for subm in submodules(m)
        moduleinfo!(db, subm)
    end

    for symbol in names(m, all=true)
        if (!isdefined(m, symbol) || symbol === :eval ||
                symbol == :include || !isfrommodule(m, symbol) || startswith(string(symbol), "#"))
            continue
        end

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
        #if (kind == "module") && (parentmodule(instance) == m) && (m != instance)
        #    push!(childmodules, instance)
        #end
        gathermethods!(db, m, symbol)
        gatherdocstring!(db, m, symbol)
    end

    for m in childmodules
        moduleinfo!(db, m)
    end
end


getsymbolid(m, symbol) = join(fullname(m), ".") * "." * string(symbol)


function gatherdocstring!(db, m, symbol)
    docstrs = getdocstrings(m, symbol)
    isempty(docstrs) && return
    docstring = join([d.docstring for d in docstrs], "\n\n---\n\n")

    instance = getfield(m, symbol)
    symbol_id = m === instance ? getmoduleid(m) : getsymbolid(m, symbol)

    push!(db[:docstrings], (; docstring, symbol_id))
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


function submodules(m::Module)
    return map(s -> getfield(m, s), filter(names(m, all=true)) do s
        isdefined(m, s) || return false
        subm = getfield(m, s)
        return subm isa Module && subm !== m && parentmodule(subm) === m
    end)
end

isfrommodule(m::Module, symbol) = isfrommodule(m, symbol, submodules(m))
function isfrommodule(m::Module, symbol, submodules)
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
    try
        docs = getproperty(m, Docs.META)
        return get(docs, binding, nothing)
    catch e
        e isa UndefVarError && return nothing
        rethrow()
    end
end

module A
    h(z) = 4

    module B
        f(x::Float16) = 1
        g(y) = 3
        export f
    end

    f(a::Int) = 2
    using .B

    export f, B
end
using .A

@testset "isfrommodule" begin
    @test !isfrommodule(A, :f)
    @test isfrommodule(B, :f)
    @test isfrommodule(B, :g)
    @test !isfrommodule(A, :g)
    @test isfrommodule(A, :h)
    @test !isfrommodule(B, :h)
end

end  # module
