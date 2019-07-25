using ImageBinarization
using Test, TestImages
using Statistics
using ImageCore, ImageTransformations
using ReferenceTests

include("testutils.jl")

@testset "ImageBinarization.jl" begin
    include("util.jl")

    include("adaptive_threshold.jl")
    # include("balanced.jl")
    # include("entropy.jl")
    # include("intermodes.jl")
    # include("minimum.jl")
    include("minimum_error.jl")
    # include("moments.jl")
    # include("niblack.jl")
    # include("otsu.jl")
    # include("polysegment.jl")
    # include("sauvola.jl")
    # include("unimodal.jl")
    # include("yen.jl")

end

nothing
