
@testset "adaptive_threshold" begin

    img = testimage("cameraman")
    img2 = testimage("cameraman")
    img3 = testimage("mandrill")

    #Basic function test without s
    @test typeof(binarize(AdaptiveThreshold(),img,15)) == typeof(testimage("cameraman"))
    #Basic mutating function test s
    binarize!(AdaptiveThreshold(),img2,15)
    @test typeof(img2) == typeof(img)
    #Ensures error is produced when bad inputs passed
    @test_throws ErrorException binarize(AdaptiveThreshold(), img3, -1)
    @test_throws ErrorException binarize(AdaptiveThreshold(), img3, 15, -2)
    @test_throws ErrorException binarize(AdaptiveThreshold(), img3, 101)

    #Ensures that the gray type passed and returned are the same
    for T in (Gray{N0f8}, Gray{N0f16}, Gray{N0f32}, Gray{Float32}, Gray{Float64})
        T.(img)
        @test typeof(binarize(AdaptiveThreshold(),img,15)) == typeof(img)
    end

    for T in (RGB{N0f8}, RGB{N0f16}, RGB{Float32}, RGB{Float64})
        T.(img3)
        @test typeof(binarize(AdaptiveThreshold(), img3, 15)) == typeof(img)
    end

end
