@testset "SingleHistogramThreshold" begin
    @info "Test: SingleHistogramThreshold"

    threshold_methods = [
        ("Balanced", Balanced()),
        ("Entropy", Entropy()),
        ("Intermodes", Intermodes()),
        ("MinimumError", MinimumError()),
        ("MinimumIntermodes", MinimumIntermodes()),
        ("Moments", Moments()),
        ("Otsu", Otsu()),
        ("UnimodalRosin", UnimodalRosin()),
        ("Yen", Yen()),
    ]

    @testset "API" begin
        img_gray = imresize(testimage("cameraman"); ratio=0.25)
        img = copy(img_gray)

        for (fname, f) in threshold_methods
            binarized_img = binarize(img, f)
            @test img == img_gray # img unchanged
            @test eltype(binarized_img) == Gray{N0f8}

            ref = copy(binarized_img)

            g = SingleHistogramThreshold(f, nbins=256)
            binarized_img = binarize(img, g)
            @test ref == binarized_img
            @test eltype(binarized_img) == Gray{N0f8}

            for alg in [f, g]
                binarized_img = binarize(Gray{Bool}, img, alg)
                @test img == img_gray # img unchanged
                @test eltype(binarized_img) == Gray{Bool}
                @test ref == binarized_img

                binarized_img = similar(img, Bool)
                binarize!(binarized_img, img, alg)
                @test img == img_gray # img unchanged
                @test eltype(binarized_img) == Bool
                @test ref == binarized_img

                binarized_img = copy(img_gray)
                binarize!(binarized_img, alg)
                @test eltype(binarized_img) == Gray{N0f8}
                @test ref == binarized_img
            end

            # binarize for SingleHistogramThreshold does not accept keyword `nbins`
            binarized_img = binarize(img, f, nbins=256)
            @test img == img_gray
            @test eltype(binarized_img) == Gray{N0f8}
            @test ref == binarized_img

            for T in generate_test_types([Float32, N0f8, Bool], [Gray])
                @test eltype(binarize(T, img, f)) == T
            end
        end
    end

    @testset "Types" begin
        # Gray
        img_gray = imresize(testimage("lena_gray_256"); ratio=0.25)
        for (fname, f) in threshold_methods
            type_list = generate_test_types([Float32, N0f8], [Gray])
            for T in type_list
                img = T.(img_gray)
                reffile = joinpath("References", fname*"_Gray.png")
                @test_reference reffile Gray.(binarize(img, f)) by=binarization_equality()
            end 
        end

        # Color3
        img_color = imresize(testimage("lena_color_256"); ratio=0.25)
        for (fname, f) in threshold_methods
            type_list = generate_test_types([Float32, N0f8], [RGB, Lab])
            for T in type_list
                img = T.(img_gray)
                reffile = joinpath("References", fname*"_Color3.png")
                @test_reference reffile Gray.(binarize(img, f)) by=binarization_equality()
            end
        end
    end

    @testset "Numerical" begin
        # Check that the image only has ones or zeros.
        img = imresize(testimage("lena_gray_256"); ratio=0.25)
        for (fname, f) in threshold_methods
            img₀₁ = binarize(img, f)
            non_zeros = findall(x -> x != 0.0 && x != 1.0, img₀₁)
            @test length(non_zeros) == 0

            # Check that ones and zeros have been assigned to the correct side of the threshold.
            maxval, maxpos = findmax(Gray.(img))
            @test img₀₁[maxpos] == 1
            minval, minpos = findmin(Gray.(img))
            @test img₀₁[minpos] == 0
        end
    end
end
