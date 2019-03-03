"""
```
img_bin = binarize(Sauvola(), img; w = 7, k = 0.2)
```

Applies Sauvola--Pietikäinen adaptive image binarization [1] under the assumption that
the input image is textual.

# Output

Returns the binarized image as an `Array{Gray{Bool},2}`.

# Details

The input image is binarized by varying the threshold across the image, using
a modified version of Niblack's algorithm [2]. Niblack's approach was to define
a threshold ``T`` for each pixel based on the mean ``m`` and standard deviation
``s`` of the intensities of neighboring pixels in a window around it, given by

```math
T(x,y) = m(x,y) + k \\cdot s(x,y),
```

where ``k`` is a user-defined parameter weighting the influence of the standard
deviation on the value of ``T``.

Niblack's algorithm is highly sensitive to variations in the gray values of
background pixels, which often exceed local thresholds and appear as artifacts
in the binarized image. Sauvola and Pietikäinen [1] introduce the dynamic range
``R`` of the standard deviation (i.e. its maximum possible value in the color
space), such that the threshold is given by

```math
T(x,y) = m(x,y) \\cdot \\left[ 1 + k \\cdot \\left( \\frac{s(x,y)}{R} - 1 \\right) \\right]
```

This adaptively amplifies the contribution made by the standard deviation to the
value of ``T``.

The Sauvola--Pietikäinen algorithm is implemented here using an optimization
proposed by Shafait, Keysers and Breuel [3], in which integral images are used
to calculate the values of ``m`` and ``s`` for each pixel in constant time.
Since each of these data structures can be computed in a single pass over the
source image, runtime is significantly improved.

# Arguments

## `img`

An `AbstractGray` image, which is binarized according to a per-pixel adaptive
threshold into background (`Gray(0)`) and foreground (`Gray(1)`) pixel values.

## `w`

The threshold for each pixel is a function of the distribution of the intensities
of all neighboring pixels in a square window around it. The side length of this
window is `2*w + 1`, with the target pixel in the center position.

## `k`

A user-defined biasing parameter. This can take negative values, though values
in the range [0.2, 0.5] are typical.



# References

1. J. Sauvola and M. Pietikäinen (2000). "Adaptive document image binarization". *Pattern Recognition* 33 (2): 225-236. [doi:10.1016/S0031-3203(99)00055-2](https://doi.org/10.1016/S0031-3203(99)00055-2)
2. Wayne Niblack (1986). *An Introduction to Image Processing*. Prentice-Hall, Englewood Cliffs, NJ: 115-16.
3. Faisal Shafait, Daniel Keysers and Thomas M. Breuel (2008). "Efficient implementation of local adaptive thresholding techniques using integral images". Proc. SPIE 6815, Document Recognition and Retrieval XV, 681510 (28 January 2008). [doi:10.1117/12.767755](https://doi.org/10.1117/12.767755)
"""
function binarize(algorithm::Sauvola, img::AbstractArray{T,2}; w::Integer = 7, k::Real = 0.2) where T <: Colorant
    binarize(algorithm, Gray.(img), w = w, k = k)
end

function binarize(algorithm::Sauvola, img::AbstractArray{T,2}; w::Integer = 7, k::Real = 0.2) where T <: AbstractGray
    img₀₁ = zeros(Gray{Bool}, axes(img))
    img_raw = channelview(img)
    I = integral_image(img_raw)
    I² = integral_image(img_raw.^2)
    R = 0.5

    function threshold(pixel::CartesianIndex{2})
        row₀, col₀, row₁, col₁ = get_window_bounds(img, pixel, w)
        m = μ_in_window(I, row₀, col₀, row₁, col₁)
        s = σ_in_window(I², m, row₀, col₀, row₁, col₁)
        return m * (1 + (k * ((s / R) - 1)))
    end

    for pixel in CartesianIndices(img)
        img₀₁[pixel] = img[pixel] <= threshold(pixel) ? 0 : 1
    end

    return img₀₁
end
