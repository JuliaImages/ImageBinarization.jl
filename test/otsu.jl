@testset "otsu" begin
    original_image = testimage("lena")
    for T in (Gray{N0f8}, Gray{N0f16}, Gray{Float32}, Gray{Float64})
        img = T.(original_image)
        img₀₁ = binarize(Otsu(), img)

        # Check original image is unchanged.
        @test img == T.(testimage("lena"))

        # Check that the image only has ones or zeros.
        non_zeros = findall(x -> x != 0.0 && x != 1.0, img₀₁)
        @test length(non_zeros) == 0

        # Check type of binarized image.
        @test typeof(img₀₁) == Array{Gray{Bool},2}

        # Check that ones and zeros have been assigned to the correct side of the threshold.
        maxval, maxpos = findmax(Gray.(img))
        @test img₀₁[maxpos] == 1
        minval, minpos = findmin(Gray.(img))
        @test img₀₁[minpos] == 0
    end
end
