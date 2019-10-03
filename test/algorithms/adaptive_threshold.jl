@testset "adaptive_threshold" begin
    @info "Test: AdaptiveThreshold"

    @testset "API" begin
        img_gray = imresize(testimage("lena_gray_256"); ratio=0.25)
        img = copy(img_gray)

        # AdaptiveThreshold
        @test AdaptiveThreshold(window_size=32) == AdaptiveThreshold(32, 15)
        @test AdaptiveThreshold(img_gray) == AdaptiveThreshold(window_size=8)

        # window_size non-positive integer
        @test_throws ArgumentError AdaptiveThreshold(window_size=-10)
        @test_throws TypeError AdaptiveThreshold(window_size=32.5)
        # percentage ∈ [0, 100]
        @test_throws ArgumentError AdaptiveThreshold(window_size=32, percentage=-10)
        @test_throws ArgumentError AdaptiveThreshold(window_size=32, percentage=150)

        # binarize
        f = AdaptiveThreshold(img, percentage=15)
        binarized_img_1 = binarize(img, f)
        @test img == img_gray # img unchanged
        @test eltype(binarized_img_1) == Gray{N0f8}

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

        for T in generate_test_types([Float32, N0f8, Bool], [Gray])
            @test eltype(binarize(T, img, f)) == T
        end
    end

    @testset "Types" begin
        # Gray
        img_gray = imresize(float64.(testimage("lena_gray_256")); ratio=0.25)
        f = AdaptiveThreshold(img_gray, percentage=15)

        type_list = generate_test_types([Float32, N0f8], [Gray])
        for T in type_list
            img = T.(img_gray)
            @test_reference "References/AdaptiveThreshold_Gray.png" Gray.(binarize(img, f))
        end

        # Color3
        img_color = imresize(float64.(testimage("lena_color_256")); ratio=0.25)
        f = AdaptiveThreshold(img_color, percentage=15)

        type_list = generate_test_types([Float32, N0f8], [RGB, Lab])
        for T in type_list
            img = T.(img_gray)
            @test_reference "References/AdaptiveThreshold_Color3.png" Gray.(binarize(img, f))
        end
    end

    @testset "Numerical" begin
        # Check that the image only has ones or zeros.
        img = imresize(float64.(testimage("lena_gray_256")); ratio=0.25)
        f = AdaptiveThreshold(img, percentage=15)
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

        # deprecations
        @test (@test_deprecated AdaptiveThreshold()) == AdaptiveThreshold(32, 15.0)
        @test (@test_deprecated AdaptiveThreshold(percentage = 15)) == AdaptiveThreshold(32, 15)
        @test (@test_deprecated recommend_size(img)) == 32
    end

end
