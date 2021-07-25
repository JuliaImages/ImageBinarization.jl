@testset "niblack" begin
    @info "Test: Niblack"

    @testset "API" begin
        img_gray = imresize(testimage("lena_gray_256"); ratio=0.25)
        img = copy(img_gray)

        # Niblack
        @test Niblack() == Niblack(7, 0.2)
        @test Niblack(7, 0.2) == Niblack(window_size=7, bias=0.2)

        # window_size non-positive integer
        @test_throws ArgumentError Niblack(window_size = -10)
        @test_throws TypeError Niblack(window_size = 32.5)

        # binarize
        f = Niblack(window_size = 7, bias=0.2)
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
        f = Niblack(window_size = 7, bias=0.2)

        type_list = generate_test_types([Float32, N0f8], [Gray])
        for T in type_list
            img = T.(img_gray)
            @test_reference "References/Niblack_Gray.png" Gray.(binarize(img, f)) by=binarization_equality()
        end

        # Color3
        img_color = imresize(testimage("lena_color_256"); ratio=0.25)
        f = Niblack(window_size = 7, bias=0.2)

        type_list = generate_test_types([Float32, N0f8], [RGB, Lab])
        for T in type_list
            img = T.(img_gray)
            @test_reference "References/Niblack_Color3.png" Gray.(binarize(img, f)) by=binarization_equality()
        end

        @testset "explicit Bool type" begin
            img_ori = imresize(testimage("cameraman"); ratio=0.25)
            for T in [RGB, Gray]
                img = T.(img_ori)
                f = Niblack()
                for out_T in [Gray{Bool}, Bool]
                    @test binarize(out_T, img, f) == out_T.(binarize(img, f))
                end
            end
        end
    end

    @testset "Numerical" begin
        # Check that the image only has ones or zeros.
        img = imresize(testimage("lena_gray_256"); ratio=0.25)
        f = Niblack(window_size = 7, bias=0.2)
        img₀₁ = binarize(img, f)
        non_zeros = findall(x -> x != 0.0 && x != 1.0, img₀₁)
        @test length(non_zeros) == 0

        # Check that ones and zeros have been assigned to the correct side of the threshold.
        maxval, maxpos = findmax(Gray.(img))
        @test img₀₁[maxpos] == 1
        minval, minpos = findmin(Gray.(img))
        @test img₀₁[minpos] == 0


        for T in (Gray{N0f8}, Gray{N0f16}, Gray{Float32}, Gray{Float64})
            img = T.([i <= 25 && j <= 25 ? 0.8 : 1.0 for i = 1:50, j = 1:50])
            target_row = target_col = 13
            img[target_row,target_col] = 0

            for i in 0:10:50, j in 0:10:50
                img₀ = circshift(img, (i,j))
                target_row₀ = (target_row + i) % 50
                target_col₀ = (target_col + j) % 50

                img_bin = binarize(img₀, Niblack(window_size = 25, bias = -6))
                @test sum(img_bin .== 0) == 1
                @test img_bin[target_row₀, target_col₀] == 0
            end
        end
    end

end
