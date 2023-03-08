function getdeps(m::Module)
    basemodule(m) === Base && return Symbol[]
    basemodule(m) === Core && return Symbol[]
    file = joinpath(Pkg.pkgdir(m), "Project.toml")
    isfile(file) || return Symbol[]
    # TODO: add support for pre-1.0 REQUIRE files
    proj = TOML.parsefile(file)
    deps = get(proj, "deps", Dict{String, String}())
    return Symbol.(collect(keys(deps)))
end


"""
    get_module_bindings(m::Module)

Find all modules of package dependencies that are imported into module `m`.
Dependencies that are not imported by `m` are not returned.
"""
function get_module_bindings(m::Module)
    [getfield(m, name)
     for name in getdeps(m)
     if isdefined(m, name) && getfield(m, name) isa Module]
end

function pkglastmodified(dir)
    maximum(Iterators.map(f -> stat(f).mtime, glob("$(relpath(dir))/**/*.jl")))
end


"""
    projectfile(module::Module)

Find the path to the Project.toml file that defines the environment of `module`.
If `module` is a package module or submodule of one, this is in the package directory.
If `module` is one of `Main`, `Base`, or `Core`, the global environment project is returned.
"""
function projectfile(m::Module)
    if Symbol(m) ∈ (:Main, :Base, :Core)
        major, minor = VERSION.major, VERSION.minor
        joinpath(Pkg.envdir(), "v$major.$minor", "Project.toml")
    else
        joinpath(pkgdir(m), "Project.toml")
    end
end

"""
    load_project_module(projectfile)
    load_project_module(projectdir)

Load the root module of the Julia project defined by `projectfile`. If it is a package
directory, return the package module. If it is a global project, return `Main`.
"""
@memoize function load_project_module(project::String = Base.active_project())
    projfile = endswith(project, "Project.toml") ? project : joinpath(project, "Project.toml")
    projconfig = TOML.parsefile(projfile)
    if "uuid" in keys(projconfig)
        # Is a package directory
        with_project(projfile) do
            pkg = projconfig["name"]
            return Base.include_string(Module(), """using $pkg; $pkg""")
        end
    else
        return Main
    end
end

"""
    load_project_dependencies(project_file) -> Module[]
    load_project_dependencies(project_dir)
    load_project_dependencies(module)

Load all package dependencies of a project or package and return them as a vector of
`Module`s.
"""
@memoize function load_project_dependencies(project::String = Base.active_project(); verbose = false, packages = nothing)
    projfile = endswith(project, "Project.toml") ? project : joinpath(project, "Project.toml")
    pkg_names = collect(keys(get(TOML.parsefile(projfile), "deps", Dict{String, Any}())))
    if !isnothing(packages)
        pkg_names = filter(in(packages), pkg_names)
    end
    m_deps = Module()

    return with_project(projfile; verbose = false) do
        map(enumerate(pkg_names)) do (i, pkg)
            m_deps_i = Base.include_string(m_deps, "Module(:__$i)")
            verbose && @info "Importing $pkg"
            Base.include_string(m_deps_i, "using $pkg; $pkg")
            getproperty(m_deps_i, Symbol(pkg))::Module
        end
    end
end
load_project_dependencies(mod::Module; verbose = false) = load_project_dependencies(projectfile(mod); verbose = false)

"""
    get_project_packages()

Return a list of names of loadable packages of a Julia project. For a package project, this
includes the package itself. It always includes the direct dependencies of the project.
"""
function get_project_packages(project::String = Base.active_project())
    projfile = endswith(project, "Project.toml") ? project : joinpath(project, "Project.toml")
    project_config = TOML.parsefile(projfile)
    packages = collect(keys(get(project_config, "deps", Dict{String, Any}())))
    package_name = get(project_config, "name", nothing)
    if package_name !== nothing
        push!(packages, package_name)
    end
    return packages
end

"""
    with_project(f, project_dir; verbose = false)
    with_project(f, module; verbose = false)

Execute function `f` with project in `project_dir` activated. If `verbose = false`, don't
print the output from switching active projects.
"""
function with_project(f, projectdir::String; verbose = false)
    suppress(f) = verbose ? f() : IOCapture.capture(f)
    proj = Base.active_project()
    if !endswith(projectdir, "Project.toml")
        projectdir = joinpath(projectdir, "Project.toml")
    end
    if projectdir == proj
        f()
    else
        try
            suppress(() -> Pkg.activate(projectdir))
            f()
        finally
            suppress(() -> proj === nothing ? Pkg.activate() : Pkg.activate(proj))
        end
    end
end
with_project(f, mod::Module; verbose = false) = with_project(f, projectfile(mod); verbose)
