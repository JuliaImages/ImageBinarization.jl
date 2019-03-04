using ImageBinarization
using Test, TestImages, ColorTypes, ColorVectorSpace, FixedPointNumbers, Statistics

@testset "ImageBinarization.jl" begin
    include("polysegment.jl")
    include("adaptive_threshold.jl")
    include("unimodal.jl")
    include("minimum.jl")
    include("intermodes.jl")
    include("minimum_error.jl")
    include("moments.jl")
    include("yen.jl")
    include("balanced.jl")
    include("otsu.jl")
    include("entropy.jl")
    include("util.jl")
    include("sauvola.jl")
    include("niblack.jl")
end
