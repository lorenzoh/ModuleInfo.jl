
#=

- Dump index to cache
    - store metadata with time of write
- Load index from cache
    - dev'ed packages should be reindexed if modified
- Allow declaratively defining package index that will be cached and
    loaded from cache where possible

=#

abstract type InfoCache end

"""
    iscached(cache, m)
    iscached(cache, pkgid)
"""
function iscached end

"""
    readfromcache(cache, m)
    readfromcache(cache, pkgid)
"""
function readfromcache end

struct NoCache <: InfoCache end

iscached(::NoCache, _) = false
function readfromcache(::NoCache, _)
    throw(ValueError("`NoCache` cannot cache, this function should not be called."))
end
writecache(::NoCache, _) = return

struct FileCache <: InfoCache
    dir::Any
end

function iscached(cache::FileCache, info::PackageInfo)
    name, version = split(getid(info), '@')
    path = joinpath(cache.dir, name, version)
    isdir(path) || return false
    if occursin(Pkg.devdir(), info.basedir)
        # in-development packages are only loaded from cache if they haven't
        # been modified since the cache was written
        cachetime = stat(joinpath(path), "packages.json").mtime
        return cachetime > pkglastmodified(info.basedir)
    else
        return true
    end
end

function readfromcache(cache::FileCache, info::PackageInfo)
    name, version = split(getid(info), '@')
    path = joinpath(cache.dir, name, version)
    readcache(path)
end

function writecache(cache::FileCache, I::PackageIndex)
    !isdir(cache.dir) && mkpath(cache.dir)
    for pkg in I.packages
        pdir = joinpath(cache.dir, pkg.name, pkg.version)
        writecache(pdir, I, getid(pkg))
    end
end

function writecache(dir, I::PackageIndex, pkgid::String)
    I_ = packageview(I, pkgid)
    mkpath(dir)
    for (k, xs) in pairs(I_.data)
        writetable(joinpath(dir, "$k.json"), xs)
    end
end

const INFOS = (packages = PackageInfo,
               modules = ModuleInfo_,
               symbols = SymbolInfo,
               bindings = BindingInfo,
               docstrings = DocstringInfo,
               files = FileInfo,
               methods = MethodInfo)

function readcache(dir)
    NamedTuple(k => readtable(joinpath(dir, "$k.json"), T) for (k, T) in pairs(INFOS))
end

# TODO: allow loading an environment
# Maybe store cache directory in index and allow loading packages on demand when necessary

writetable(file::String, xs) = open(f -> writetable(f, xs), file, "w")
writetable(io::IO, xs) = JSON3.write(io, xs)

readtable(file::String, T) = open(f -> readtable(f, T), file, "r")
readtable(io::IO, T) = StructArray(JSON3.read(io, Vector{T}))

packageview(I::PackageIndex, pkgid::String) = packageview(I, [pkgid])

function packageview(I::PackageIndex, pkgids)
    pkgids = Set(pkgids)
    packages = @view I.packages[map(in(pkgids) ∘ getid, I.packages)]#getid.(I.packages) .∈ pkgids]
    files = @view I.files[map(in(pkgids), I.files.package_id)]
    modules = @view I.modules[map(in(pkgids), I.modules.package_id)]
    module_ids = Set(modules.id)
    symbols = @view I.symbols[map(in(module_ids), I.symbols.module_id)]
    methods = @view I.methods[map(in(module_ids), I.methods.module_id)]
    docstrings = @view I.docstrings[map(in(module_ids), I.docstrings.module_id)]
    bindings = @view I.bindings[map(in(module_ids), I.bindings.module_id)]
    return PackageIndex((; packages, files, modules, symbols, methods, docstrings,
                         bindings))
end

# TODo: views, write to folders, load it again. reload packages that are
# outdated
