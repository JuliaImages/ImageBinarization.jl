using ImageBinarization
using Test, TestImages
using Statistics
using ImageCore, ImageTransformations
using ReferenceTests

include("testutils.jl")

@testset "ImageBinarization.jl" begin
    include("util.jl")

    include("algorithms/adaptive_threshold.jl")
    include("algorithms/balanced.jl")
    include("algorithms/entropy.jl")
    include("algorithms/intermodes.jl")
    include("algorithms/minimum.jl")
    include("algorithms/minimum_error.jl")
    include("algorithms/moments.jl")
    include("algorithms/niblack.jl")
    include("algorithms/otsu.jl")
    include("algorithms/polysegment.jl")
    include("algorithms/sauvola.jl")
    include("algorithms/unimodal.jl")
    include("algorithms/yen.jl")
end

nothing
