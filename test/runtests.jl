using ImageBinarization, Images, TestImages
using Test

@testset "ImageBinarization.jl" begin
    include("minimum.jl")
    include("intermodes.jl")
end
