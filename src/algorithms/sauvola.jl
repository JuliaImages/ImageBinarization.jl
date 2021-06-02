"""
    Sauvola <: AbstractImageBinarizationAlgorithm
    Sauvola(; bias = 0.2, window_size=7)

    binarize([T,] img, f::Sauvola)
    binarize!([out,] img, f::Sauvola)

Applies Sauvola--Pietikäinen adaptive image binarization [1] under the
assumption that the input image is textual.

# Output

Return the binarized image as an `Array{Gray{T}}` of size `size(img)`. If
`T` is not specified, it is inferred from `out` and `img`.

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

An image which is binarized according to a per-pixel adaptive
threshold into background (0) and foreground (1) pixel values.

## `window_size::Integer` (denoted by ``w`` in the publication)

The threshold for each pixel is a function of the distribution of the intensities
of all neighboring pixels in a square window around it. The side length of this
window is ``2w + 1``, with the target pixel in the center position.

## `bias::Real` (denoted by ``k`` in the publication)

A user-defined biasing parameter. This can take negative values, though values
in the range [0.2, 0.5] are typical. According to [1], this algorithm is not too
sensitive to the value of ``k```.

# Example

Binarize the "cameraman" image in the `TestImages` package.

```julia
using TestImages, ImageBinarization

img = testimage("cameraman")
img_binary = binarize(img, Sauvola(window_size = 9, bias = 0.2))
```

# References

1. J. Sauvola and M. Pietikäinen (2000). "Adaptive document image binarization". *Pattern Recognition* 33 (2): 225-236. [doi:10.1016/S0031-3203(99)00055-2](https://doi.org/10.1016/S0031-3203(99)00055-2)
2. Wayne Niblack (1986). *An Introduction to Image Processing*. Prentice-Hall, Englewood Cliffs, NJ: 115-16.
3. Faisal Shafait, Daniel Keysers and Thomas M. Breuel (2008). "Efficient implementation of local adaptive thresholding techniques using integral images". Proc. SPIE 6815, Document Recognition and Retrieval XV, 681510 (28 January 2008). [doi:10.1117/12.767755](https://doi.org/10.1117/12.767755)
"""
struct Sauvola <: AbstractImageBinarizationAlgorithm
    window_size::Int
    bias::Float32

    function Sauvola(window_size::Integer, bias::Real)
        window_size < 0 && throw(ArgumentError("window_size should be non-negative."))
        new(window_size, bias)
    end
end

Sauvola(; window_size::Int = 7, bias::Real = 0.2) = Sauvola(window_size, bias)

function (f::Sauvola)(out::GenericGrayImage, img::GenericGrayImage)
    img = of_eltype(floattype(eltype(img)), img)

    window_size = f.window_size
    k = f.bias

    size(out) == size(img) || throw(ArgumentError("out and img should have the same shape, instead they are $(size(out)) and $(size(img))"))

    img_raw = channelview(img)
    I = integral_image(img_raw)
    I² = integral_image(img_raw.^2)
    R = 0.5 # dynamic range of standard deviation, in [1] it's set to 128 for 8-bit image

    function threshold(pixel::CartesianIndex{2})
        row₀, col₀, row₁, col₁ = get_window_bounds(img, pixel, window_size)
        m = μ_in_window(I, row₀, col₀, row₁, col₁)
        s = σ_in_window(I², m, row₀, col₀, row₁, col₁)
        return m * (1 + (k * ((s / R) - 1)))
    end

    @simd for pixel in CartesianIndices(img)
        out[pixel] = img[pixel] <= threshold(pixel) ? 0 : 1
    end

    return out
end

(f::Sauvola)(out::GenericGrayImage, img::AbstractArray{<:Color3}) =
    f(out, eltype(out).(img))
