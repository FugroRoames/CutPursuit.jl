
module CutPursuit

using CxxWrap

const depsjl_path = joinpath(@__DIR__, "..", "deps", "deps.jl")
if !isfile(depsjl_path)
    error("LibCutPursuit not installed properly, run Pkg.build(\"CutPursuit\"), restart Julia and try again")
end
include(depsjl_path)
check_deps()

function __init__()
    @initcxx
end

# Wrap cut pursuit c++ code

struct StdVector{T}# <: AbstractVector{T}
    # ptr::Int
    start::Ptr{T}
    end_::Ptr{T}
    buffer_end::Ptr{T}
end

Base.size(v::StdVector) = v.end_ - v.start
Base.axes(v::StdVector) = Base.OneTo(v.end_ - v.start)
@inline function Base.getindex(v::StdVector{T}, i::Int) where {T}
    # @boundscheck checkbounds(v, i)
    unsafe_load(v.start, i-1)
end

@inline function Base.setindex!(v::StdVector{T}, value::T, i::Int) where {T}
    @boundscheck checkbounds(v, i)
    unsafe_store!(v.start, value, i-1)
end

export StdVector

@wrapmodule(joinpath("/home/josh/dev/superpoint_graph/partition/cut-pursuit/src/", "libcpjl"))

# @wrapmodule libcpjl

export cut_pursuit

# solution = unsafe_load(Base.unsafe_convert(Ptr{StdVector{Float32}}, a.cpp_object))

function test()
    # obs =
    # source =
    # target =
    # edge_weight =
    a = cut_pursuit(rand(100,2), rand(Int32(1):Int32(100), 100), Int32.(rand(1:100,100)))
    c = CutPursuit.in_components_test(a);
    s = StdVector(c[1], Ptr{UInt32}(c[2]),Ptr{UInt32}(c[3]))
    # this works -> unsafe_wrap(Array, s.start, size(s))


    solution = unsafe_load(Base.unsafe_convert(Ptr{StdVector{UInt32}}, c))
end

function cut_pursuit(obs::AbstractArray{T1, 2},
                     source::AbstractVector{T2},
                     target::AbstractVector{T2}; kwargs...) where {T1 <: Number, T2 <: Integer}

    edge_weight = ones(Float64, length(source))
    node_weight = ones(Float64, length(source))

    cut_pursuit(obs,
                source,
                target,
                edge_weight,
                node_weight;
                kwargs...)
end

function cut_pursuit(obs,
                     source,
                     target,
                     edge_weight,
                     node_weight;
                     lambda::T2  = 1f0,
                     mode::T2    = 1f0,
                     speed::T2   = 1f0,
                     verbose::T2 = 2f0) where {T2 <: Float32}

    n_nodes, n_obs = size(obs) # number of nodes, number of observations
    n_edge = length(source)


    solution = cut_pursuit(UInt32(n_nodes), UInt32(n_edge), UInt32(n_obs), obs, source, target, edge_weight, node_weight, lambda, mode, speed, verbose)

    return solution
end

end # module
