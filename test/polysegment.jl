@testset "Polysegment Binarization" begin
    # Verify that the output type matches the input type.
    img = testimage("lena")
    for T in (Gray{N0f8}, Gray{N0f16}, Gray{Float32}, Gray{Float64})
        img₁ = T.(img)
        img₂ = binarize(Polysegment(), img₁)
        @test eltype(img₁) == eltype(img₂)
    end
end
