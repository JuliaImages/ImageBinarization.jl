using ImageBinarization
using Test, TestImages, ColorTypes, ColorVectorSpace, FixedPointNumbers

@testset "ImageBinarization.jl" begin
    include("polysegment.jl")
    include("minimum.jl")
    include("intermodes.jl")
    include("minimum_error.jl")
end
