module ModuleInfo

using CodeTracking: pkgfiles, whereis
using StructArrays: StructArray
using InlineTest
using Markdown
using Memoize: @memoize
using DataFrames
using Pkg
import Scratch
import JSON3
import StructTypes
import TOML
import Glob: glob

const Maybe{T} = Union{Nothing, T}

include("types.jl")
include("store.jl")
include("introspection.jl")
include("project.jl")
include("index.jl")
include("find.jl")
include("cache.jl")

export PackageIndex

module A
h(z) = 4

module B
f(x::Float16) = 1
g(y) = 3
export f
end

B.f(a::Int) = 2
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

const CACHE = Ref{InfoCache}(NoCache())

function __init__()
    CACHE[] = FileCache(Scratch.@get_scratch!("cache"))
end

end  # module
