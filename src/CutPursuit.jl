
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

@wrapmodule libcpjl

export cut_pursuit

function test()
    # obs =
    # source =
    # target =
    # edge_weight =

    cut_pursuit(rand(100,2), Int32.(rand(1:100, 100)), Int32.(rand(1:100,100)), ones(Float64,100))
end

end # module
