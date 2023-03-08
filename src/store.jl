
struct PackageIndex{TData, TIndex}
    data::TData
    index::TIndex
end

PackageIndex() = PackageIndex(newdata(), newindex())

"""
    PackageIndex(modules; kwargs...)

Index the packages that define `modules`. The created index contains tables of the following
data associated with the packages:

- packages
- modules
- symbols
- methods
- docstrings
- source files
- bindings

## Keyword arguments

- `cache = false`: Cache to use to store the index. If `true`, use the default, global
    file-based cache (`ModuleInfo.CACHE[]`). You can also pass a [`InfoCache`](#) directly.
    If a cache is used, already indexed packages will not be reindexed. In-development
    packages _will_ be reindexed if they have changed since the cache was built.
- `verbose = false`: If `true`, print which package is being indexed while running.
- `packages = nothing`: Pass a `Vector{String}` to limit which packages are indexed to those
    specified. Useful when using the `recurse` option and you only want to index some
    dependencies.
- `recurse = 0`: How many levels to recurse into `packages`' dependencies. The default `0`
    means no dependencies are indexed. `1` would mean that only direct dependencies
    of every package in `packages` are indexed.
- `pkgtags = Dict{String, String}()`: A mapping of `package_name => version_name` that can
    be used to overwrite the version that a package will be saved as.

## Examples

Index a package:

{cell}
```julia
using ModuleInfo
pkgindex = PackageIndex([ModuleInfo])
```

Index a package and its direct dependencies:

{cell}
```julia
using ModuleInfo
pkgindex = PackageIndex([ModuleInfo], recurse = 1)
ModuleInfo.getid.(pkgindex.packages)
```
"""
function PackageIndex(ms::Vector{Module}; cache = true, kwargs...)
    cache = cache isa Bool ? (cache ? CACHE[] : NoCache()) : cache
    pkgindex = PackageIndex()
    visited = Set{String}()
    foreach(ms) do m
        indexpackage!(pkgindex, m; cache, visited, kwargs...)
    end
    writecache(cache, pkgindex)
    return pkgindex
end

PackageIndex(m::Module; kwargs...) = PackageIndex([m]; kwargs...)

function PackageIndex(project::String; kwargs...)
    mod = load_project_module(project);
    if Symbol(mod) === :Main
        mod = load_project_dependencies(project)
    end
    PackageIndex(mod; kwargs...)
end

PackageIndex(data::NamedTuple) = PackageIndex(data, __createindex(data))


function Base.show(io::IO, pkgindex::PackageIndex)
    print(io, "PackageIndex(")
    for (i, (k, entries)) in enumerate(pairs(pkgindex.data))
        n = length(entries)
        printstyled(io, n, bold = true)
        print(io, " ")
        name = n == 1 ? string(k)[1:(end - 1)] : k
        print(io, "\e[2m", name, "\e[22m")
        i < length(pkgindex.data) && print(io, ", ")
    end
    print(io, ")")
end

"""
    extend!(pkgindex, data)

Add `*Info` entries to an existing `PackageIndex`.
"""
function extend!(pkgindex::PackageIndex, data::NamedTuple; overwrite = false)
    for x in Iterators.flatten(values(data))
        addentry!(pkgindex, x; overwrite)
    end
    return pkgindex
end

function Base.getproperty(pkgindex::PackageIndex, k::Symbol)
    data = getfield(pkgindex, :data)
    if k in keys(data)
        return (data[k])
    else
        return getfield(pkgindex, k)
    end
end

Base.propertynames(pkgindex::PackageIndex) = keys(getfield(pkgindex, :data))


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



@testset "PackageIndex" begin
    @testset "Default" begin
        pkgindex = PackageIndex([ModuleInfo])
        @test length(pkgindex.packages) == 1
        @test "ModuleInfo.PackageIndex" in pkgindex.symbols.id
        @test "PackageIndex" in pkgindex.symbols.name
    end
    @testset "Find" begin
        pkgindex = PackageIndex([ModuleInfo])
        @test_nowarn getpackages(pkgindex)
        @test_nowarn getsymbols(pkgindex)
        @test_nowarn getmethods(pkgindex)
    end
    @testset "(; recurse, packages)" begin
        pkgindex = PackageIndex([ModuleInfo], recurse = 1)
        @test length(pkgindex.packages) > 2

        pkgindex = PackageIndex([ModuleInfo], recurse = 1, packages = ["ModuleInfo", "Pkg"])
        @test length(pkgindex.packages) == 2
    end
    @testset "cache" begin
        mktempdir() do dir
            cache = FileCache(dir)
            pkgindex = PackageIndex([ModuleInfo]; cache)
            @test iscached(cache, pkgindex.packages[1])
        end
    end
end
