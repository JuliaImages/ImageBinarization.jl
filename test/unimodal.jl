@testset "unimodal" begin

    img = testimage("moonsurface")
    img2 = copy(img)
    img_binary = binarize(UnimodalRosin(), img2)

    # check that the original image has not been changed
    @test img == img2

    # Check that the ! version of the function modifies the parameters
    img3 = copy(img)
    binarize!(UnimodalRosin(),img3)
    @test img3 != img

    # Check that the only entries in the image are 1 or 0.
    non_zeros = findall(x-> x != 0.0 && x != 1.0, img_binary)
    @test length(non_zeros) == 0

    # Check that output and input image are same type
    @test typeof(img_binary) == typeof(img)

    # Check that ones and zeroes have benn assigned to correct sides.
    max, maxpos = findmax(img)
    @test img_binary[maxpos] == 1
    min, minpos = findmin(img)
    @test img_binary[minpos] == 0


end
