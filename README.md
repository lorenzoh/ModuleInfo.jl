# ModuleInfo.jl

A Julia package that makes it easy to index package data, including information on a package's modules, docstrings, source files, definitions and bindings.

Features:

- index packages, with support for recursively indexing dependencies and caching
- searching and filtering
- use index data with all Tables.jl-compliant data sinks, e.g. DataFrames.jl
- resolve identifiers in a module scope to find the symbol they refer to

Here we index `Base` and all its submodules:

```julia-repl
julia> pkgindex = PackageIndex([Base])
PackageIndex(1 package, 42 modules, 203 files, 3847 symbols, 7892 methods, 1267 docstrings, 5385 bindings)
```

```julia-repl
julia> DataFrame(pkgindex.modules)
42×3 DataFrame
 Row │ id                          parent                package_id 
     │ String                      Union…                String     
─────┼──────────────────────────────────────────────────────────────
   1 │ Base                        Main                  Base@1.8.1
   2 │ Base.BaseDocs               Base                  Base@1.8.1
   3 │ Base.BinaryPlatforms        Base                  Base@1.8.1
   4 │ Base.BinaryPlatforms.CPUID  Base.BinaryPlatforms  Base@1.8.1
   5 │ Base.Broadcast              Base                  Base@1.8.1
  ⋮  │             ⋮                        ⋮                ⋮
  39 │ Base.Sys                    Base                  Base@1.8.1
  40 │ Base.TOML                   Base                  Base@1.8.1
  41 │ Base.Threads                Base                  Base@1.8.1
  42 │ Base.Unicode                Base                  Base@1.8.1
                                                     33 rows omitted
```



