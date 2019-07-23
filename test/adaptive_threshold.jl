using ImageBinarization: default_AdaptiveThreshold_window_size
@testset "adaptive_threshold" begin
    @info "Test: AdaptiveThreshold"

    @testset "API" begin
        img_gray = imresize(testimage("lena_gray_256"); ratio=0.25)
        img = copy(img_gray)

        # AdaptiveThreshold
        @test AdaptiveThreshold() == AdaptiveThreshold(15)
        @test AdaptiveThreshold(15) == AdaptiveThreshold(percentage=15)

        # window_size non-positive integer
        f = AdaptiveThreshold()
        @test_throws ArgumentError binarize(img, f, window_size = -10)
        @test_throws TypeError binarize(img, f, window_size = 32.5)
        # percentage ∈ [0, 100]
        @test_throws ArgumentError AdaptiveThreshold(-10)
        @test_throws ArgumentError AdaptiveThreshold(150)

        # binarize
        f = AdaptiveThreshold(percentage=15)
        binarized_img_1 = binarize(img, f)
        @test img == img_gray # img unchanged
        @test eltype(binarized_img_1) == Gray{N0f8}
        @test binarize(img, f,
                       window_size=default_AdaptiveThreshold_window_size(img)) == binarized_img_1

        binarized_img_2 = binarize(Gray{Bool}, img, f)
        @test img == img_gray # img unchanged
        @test eltype(binarized_img_2) == Gray{Bool}

        binarized_img_3 = similar(img, Bool)
        binarize!(binarized_img_3, img, f)
        @test img == img_gray # img unchanged
        @test eltype(binarized_img_3) == Bool

        binarized_img_4 = copy(img_gray)
        binarize!(binarized_img_4, f)
        @test eltype(binarized_img_4) == Gray{N0f8}

        @test binarized_img_1 == binarized_img_2
        @test binarized_img_1 == binarized_img_3
        @test binarized_img_1 == binarized_img_4
    end

    @testset "Types" begin
        # Gray
        img_gray = imresize(float64.(testimage("lena_gray_256")); ratio=0.25)
        f = AdaptiveThreshold(percentage=15)

        type_list = generate_test_types([Float32, N0f8], [Gray])
        for T in type_list
            img = T.(img_gray)
            @test_reference "References/AdaptiveThreshold_Gray.png" Gray.(binarize(img, f))
        end

        # Color3
        img_color = imresize(float64.(testimage("lena_color_256")); ratio=0.25)
        f = AdaptiveThreshold(percentage=15)

        type_list = generate_test_types([Float32, N0f8], [RGB, Lab])
        for T in type_list
            img = T.(img_gray)
            @test_reference "References/AdaptiveThreshold_Color3.png" Gray.(binarize(img, f))
        end
    end

    @testset "Numerical" begin
        # Check that the image only has ones or zeros.
        img = imresize(float64.(testimage("lena_gray_256")); ratio=0.25)
        f = AdaptiveThreshold(percentage=15)
        img₀₁ = binarize(img, f)
        non_zeros = findall(x -> x != 0.0 && x != 1.0, img₀₁)
        @test length(non_zeros) == 0

        # Check that ones and zeros have been assigned to the correct side of the threshold.
        maxval, maxpos = findmax(Gray.(img))
        @test img₀₁[maxpos] == 1
        minval, minpos = findmin(Gray.(img))
        @test img₀₁[minpos] == 0
    end

    @testset "Miscellaneous" begin
        img = testimage("lena_gray_256")
        @test default_AdaptiveThreshold_window_size(img) == 32

        # deprecations
        @test (@test_deprecated AdaptiveThreshold(32, 15)) == AdaptiveThreshold(15)
        @test (@test_deprecated AdaptiveThreshold(window_size=32, percentage=15)) == AdaptiveThreshold(percentage=15)
        @test (@test_deprecated recommend_size(img)) == ImageBinarization.default_AdaptiveThreshold_window_size(img)
    end

end
