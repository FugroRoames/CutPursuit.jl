
module CutPursuit

using CxxWrap

export cut_pursuit

const depsjl_path = joinpath(@__DIR__, "..", "deps", "deps.jl")
if !isfile(depsjl_path)
    error("LibCutPursuit not installed properly, run Pkg.build(\"CutPursuit\"), restart Julia and try again")
end
include(depsjl_path)

"""
Get cut_pursuit c++ code
"""

@wrapmodule(joinpath(@__DIR__, "..", "deps", "usr", "lib", "libcpjl.so"))

end # module
