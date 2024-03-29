abstract type AbstractInfo end
struct PackageInfo <: AbstractInfo
    name::String     # ModuleInfo
    uuid::String     # 3c3ff5e7-c68c-4a09-80d1-9526a1e9878a
    version::String  # v"0.1"
    basedir::String  # /home/user/.julia/dev/ModuleInfo
    dependencies::Vector{String}  # ["LinearAlgebra"]
end

getid(info::PackageInfo) = "$(info.name)@$(info.version)"

struct ModuleInfo_ <: AbstractInfo
    id::String
    parent::Maybe{String}
    package_id::String
end

struct FileInfo <: AbstractInfo
    package_id::String
    file::String
end

getid(info::FileInfo) = "$(info.package_id)/$(info.file)"

struct SymbolInfo <: AbstractInfo
    id::String
    name::String
    module_id::String
    parent_module_id::Maybe{String}
    kind::Symbol
    # Whether the module that defines the symbol exports it
    exported::Bool
end

struct DocstringInfo <: AbstractInfo
    symbol_id::String
    module_id::String
    docstring::String
    file::String
    line::Int
end
getid(info::DocstringInfo) = "$(info.symbol_id)@$(info.module_id)/$(info.file):$(info.line)"

struct MethodInfo <: AbstractInfo
    symbol_id::String
    module_id::String
    file::String
    line::Int
    signature::String
end
getid(info::MethodInfo) = "$(info.symbol_id)@$(info.module_id)/$(info.file):$(info.line)"

struct BindingInfo <: AbstractInfo
    # ID is the module ID and binding name
    id::String
    # The name of the binding
    name::String
    # The module where the binding exists
    module_id::String
    # The ID of the symbol that the binding refers to. The binding may refer to a different
    # module
    symbol_id::String
    # Whether the module where the binding is defined exports it.
    exported::Bool
end

getid(info) = info.id

StructTypes.StructType(::Type{<:AbstractInfo}) = StructTypes.OrderedStruct()
getkey(::PackageInfo) = :packages
getkey(::ModuleInfo_) = :modules
getkey(::SymbolInfo) = :symbols
getkey(::DocstringInfo) = :docstrings
getkey(::FileInfo) = :files
getkey(::MethodInfo) = :methods
getkey(::BindingInfo) = :bindings
