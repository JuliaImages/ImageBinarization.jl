@testset "intermodes" begin
    @info "Test: Intermodes"

    @testset "API" begin
        img_gray = imresize(testimage("lena_gray_256"); ratio=0.25)
        img = copy(img_gray)

        # binarize
        f = Intermodes()
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
        img_gray = imresize(testimage("lena_gray_256"); ratio=0.25)
        f = Intermodes()

        type_list = generate_test_types([Float32, N0f8], [Gray])
        for T in type_list
            img = T.(img_gray)
            @test_reference "References/Intermodes_Gray.png" Gray.(binarize(img, f)) by=binarization_equality()
        end

        # Color3
        img_color = imresize(testimage("lena_color_256"); ratio=0.25)
        f = Intermodes()

        type_list = generate_test_types([Float32, N0f8], [RGB, Lab])
        for T in type_list
            img = T.(img_gray)
            @test_reference "References/Intermodes_Color3.png" Gray.(binarize(img, f)) by=binarization_equality()
        end
    end

    @testset "Numerical" begin
        # Check that the image only has ones or zeros.
        img = imresize(testimage("lena_gray_256"); ratio=0.25)
        f = Intermodes()
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
