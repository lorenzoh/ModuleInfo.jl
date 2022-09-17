function getdeps(m::Module)
    m === Base && return Symbol[]
    m === Core && return Symbol[]
    file = joinpath(Pkg.pkgdir(m), "Project.toml")
    isfile(file) || return Symbol[]
    # TODO: add support for pre-1.0 REQUIRE files
    proj = TOML.parsefile(file)
    deps = get(proj, "deps", Dict{String, String}())
    return Symbol.(collect(keys(deps)))
end

# TODO: search child modules for import
function getdepmodules(m::Module)
    [getfield(m, name)
     for name in getdeps(m)
     if isdefined(m, name) && getfield(m, name) isa Module]
end

function pkglastmodified(dir)
    maximum(Iterators.map(f -> stat(f).mtime, glob("$(relpath(dir))/**/*.jl")))
end
