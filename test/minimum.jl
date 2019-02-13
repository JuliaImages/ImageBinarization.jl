@testset "minimum" begin
    img = testimage("cameraman")
    img2 = copy(img)
    img_binary = binarize(MinimumIntermodes(), img)

    #check original img is unchanged
    @test img == img2

    #check that the image only has ones or zeros
    non_zeros = findall(x -> x != 0.0 && x != 1.0, img_binary)
    @test length(non_zeros) == 0

    #check type of outputed img
    @test typeof(img_binary) == typeof(img)

    #check ones and zeros have been assigned to the correct side of the threshold
    max,maxpos=findmax(img)
    @test img_binary[maxpos] == 1
    min,minpos=findmin(img)
    @test img_binary[minpos] == 0
end
