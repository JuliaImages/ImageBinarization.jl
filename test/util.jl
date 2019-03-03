@testset "Util" begin

    # Test `get_window_bounds()`.
    let A = Gray.(zeros(5,5))
        for index in CartesianIndices(A)
            bounds = ImageBinarization.get_window_bounds(A, index, 1)
            for bound = bounds
                @test 1 <= bound <= 5
            end
        end
    end

    # Test `μ_in_window()`.
    let A = [(x-1) * 5 + y for x = 1:5, y = 1:5]
        I = ImageBinarization.integral_image(A)
        for r₀ in 1:5, c₀ in 1:5
            for r₁ in r₀:5, c₁ in c₀:5
                @test ImageBinarization.μ_in_window(I, r₀, c₀, r₁, c₁) == mean(vec(A[r₀:r₁,c₀:c₁]))
            end
        end
    end

    # Test `σ²_in_window()`.
    let A = [(x-1) * 5 + y for x = 1:5, y = 1:5]
        I² = ImageBinarization.integral_image(A.^2)
        for r₀ in 1:5, c₀ in 1:5
            for r₁ in r₀:5, c₁ in c₀:5
                μ = mean(vec(A[r₀:r₁,c₀:c₁]))
                δ = ImageBinarization.σ²_in_window(I², μ, r₀, c₀, r₁, c₁) - var(vec(A[r₀:r₁,c₀:c₁]), corrected=false)
                @test δ == NaN || δ < 1e-10
            end
        end
    end

    # Test `σ_in_window()`.
    let A = [(x-1) * 5 + y for x = 1:5, y = 1:5]
        I² = ImageBinarization.integral_image(A.^2)
        for r₀ in 1:5, c₀ in 1:5
            for r₁ in r₀:5, c₁ in c₀:5
                μ = mean(vec(A[r₀:r₁,c₀:c₁]))
                δ = ImageBinarization.σ_in_window(I², μ, r₀, c₀, r₁, c₁) - std(vec(A[r₀:r₁,c₀:c₁]), corrected=false)
                @test δ == NaN || δ < 1e-10
            end
        end
    end
end
