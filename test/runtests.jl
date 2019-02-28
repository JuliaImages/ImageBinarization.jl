using ImageBinarization
using Test, TestImages, ColorTypes, ColorVectorSpace, FixedPointNumbers

@testset "ImageBinarization.jl" begin
    include("polysegment.jl")
    include("unimodal.jl")
    include("minimum.jl")
    include("intermodes.jl")
    include("minimum_error.jl")
    include("yen.jl")
    include("balanced.jl")
    include("otsu.jl")
    include("entropy.jl")
end
