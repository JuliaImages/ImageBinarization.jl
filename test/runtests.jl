using ImageBinarization
using Test, TestImages
using Statistics
using ImageCore, ImageTransformations
using OffsetArrays
using ReferenceTests

include("testutils.jl")

@testset "ImageBinarization.jl" begin
    include("util.jl")

    include("algorithms/single_histogram_threshold.jl")
    include("algorithms/adaptive_threshold.jl")
    include("algorithms/niblack.jl")
    include("algorithms/polysegment.jl")
    include("algorithms/sauvola.jl")
end

nothing
