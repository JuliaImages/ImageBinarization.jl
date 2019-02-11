using ImageBinarization
using Test, TestImages, ColorTypes, ColorVectorSpace, FixedPointNumbers

@testset "ImageBinarization.jl" begin
    include("polysegment.jl")
    include("unimodal.jl")
end
