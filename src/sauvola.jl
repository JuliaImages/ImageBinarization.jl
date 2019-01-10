"""
```
img_bin = binarize(Sauvola(), img, w = 7, k = 0.34)
img_bin = binarize!(Sauvola(), img, w = 7, k = 0.34)
```

Binarizes an input image using the Sauvola--Pietikäinen adaptive thresholding
technique [1]. The threshold for each target pixel is a function of the mean and
standard deviation of the intensities of all neighboring pixels in a window
around the target. An optimization using integral images to calculate these
descriptive statistics has been implemented [2].

# Parameters

## `img`

An `AbstractGray` image which is binarized into background (`Gray(0)`) and
foreground (`Gray(1)`).

## `w`

The size (in pixels) of the offset from the target delineating the window around
it. The side length of the window is given by `2*w + 1`, with the target pixel
in the center position.

## `k`

A user-defined biasing parameter. Takes negative values, though values in the
range [0.2, 0.5] are typical. Note that the algorithm is not too sensitive to
changes in `k`.

# References

[1] J. Sauvola and M. Pietikäinen (2000). "Adaptive document image binarization". *Pattern Recognition* 33 (2): 225-236. [doi:10.1016/S0031-3203(99)00055-2](https://doi.org/10.1016/S0031-3203(99)00055-2)
[2] Faisal Shafait, Daniel Keysers and Thomas M. Breuel (2008). "Efficient implementation of local adaptive thresholding techniques using integral images". Proc. SPIE 6815, Document Recognition and Retrieval XV, 681510 (28 January 2008). [doi:10.1117/12.767755](https://doi.org/10.1117/12.767755)
"""

function binarize(algorithm::Sauvola, img::AbstractArray{T,2}; w::Integer = 7, k::Real = 0.34) where T <: AbstractGray
    binarize!(algorithm, copy(img), w=w, k=k)
end

function binarize!(algorithm::Sauvola, img::AbstractArray{T,2}; w::Integer = 7, k::Real = 0.34) where T <: AbstractGray
    # Construct the two integral images by looking into the Gray elements of the
    # source to their underlying type.
    I = integral_image(channelview(img))
    I² = integral_image(channelview(img.^2))
    R = 0.5

    function threshold(pixel::CartesianIndex)
        row₀, col₀, row₁, col₁ = get_window_bounds(img, pixel, w)

        μ = μ_in_window(I, row₀, col₀, row₁, col₁)
        σ = σ_in_window(I², μ, row₀, col₀, row₁, col₁)

        return μ * (1 + (k * ((σ / R) - 1)))
    end

    for pixel in CartesianIndices(img)
        img[pixel] = img[pixel] <= threshold(pixel) ? Gray(0) : Gray(1)
    end

    return img
end
