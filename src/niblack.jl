@doc raw"""
    Niblack <: AbstractImageBinarizationAlgorithm
    Niblack(; bias = 0.2)

    binarize([T,] img, f::Niblack; [window_size])
    binarize!([out,] img, f::Niblack; [window_size])

Applies Niblack adaptive thresholding [1] under the assumption that the input
image is textual.

# Output

Return the binarized image as an `Array{Gray{T}}` of size `size(img)`. If
`T` is not specified, it is inferred from `out` and `img`.

# Details

The input image is binarized by varying the threshold across the image, using
a modified version of Niblack's algorithm [2]. A threshold ``T`` is defined for
each pixel based on the mean ``m`` and standard deviation ``s`` of the
intensities of neighboring pixels in a window around it. This threshold is given
by

```math
T(x,y) = m(x,y) + k \cdot s(x,y),
```

where ``k`` is a user-defined parameter weighting the influence of the standard
deviation on the value of ``T``.

Note that Niblack's algorithm is highly sensitive to variations in the gray
values of background pixels, which often exceed local thresholds and appear as
artifacts in the binarized image. The [`Sauvola`](@ref) algorithm included in
this package implements an attempt to address this issue [2].

# Arguments

## `img`

An image which is binarized according to a per-pixel adaptive
threshold into background (0) and foreground (1) pixel values.

## `bias::Real`  (denoted by ``k`` in the publication)

A user-defined biasing parameter on threshold. This can take negative values.
Larger `bias` encourages more black pixels in the output.

## `window_size::Integer` (denoted by ``w`` in the publication)

The threshold for each pixel is a function of the distribution of the intensities
of all neighboring pixels in a square window around it. The side length of this
window is ``2w + 1``, with the target pixel in the center position.

If not specified, `window_size` is `7`.

!!! info

    `window_size` is a keyword argument in [`binarize`](@ref) and [`binarize!`](@ref)

# Example

Binarize the "cameraman" image in the `TestImages` package.

```julia
using TestImages, ImageBinarization

img = testimage("cameraman")
img₀₁ = binarize(img, Niblack())
```

# References

[1] Wayne Niblack (1986). *An Introduction to Image Processing*. Prentice-Hall, Englewood Cliffs, NJ: 115-16.
[2] J. Sauvola and M. Pietikäinen (2000). "Adaptive document image binarization". *Pattern Recognition* 33 (2): 225-236. [doi:10.1016/S0031-3203(99)00055-2](https://doi.org/10.1016/S0031-3203(99)00055-2)
"""
struct Niblack <: AbstractImageBinarizationAlgorithm
    bias::Float32
end

function Niblack(; window_size = nothing, bias::Real = 0.2)
    if window_size !== nothing
        # deprecate window_size
        return Niblack(window_size, bias)
    else
        return Niblack(bias)
    end
end

function (f::Niblack)(out::GenericGrayImage,
                      img::GenericGrayImage;
                      window_size::Union{Integer, Nothing} = nothing)

    if window_size === nothing
        window_size = default_Niblack_window_size(img)
    end

    window_size < 0 && throw(ArgumentError("window_size should be non-negative."))
    size(out) == size(img) || throw(ArgumentError("out and img should have the same shape, instead they are $(size(out)) and $(size(img))"))

    k = f.bias
    img_raw = channelview(img)
    I = integral_image(img_raw)
    I² = integral_image(img_raw.^2)

    function threshold(pixel::CartesianIndex{2})
        row₀, col₀, row₁, col₁ = get_window_bounds(img, pixel, window_size)
        m = μ_in_window(I, row₀, col₀, row₁, col₁)
        s = σ_in_window(I², m, row₀, col₀, row₁, col₁)
        return m + (k * s)
    end

    @simd for pixel in CartesianIndices(img)
        out[pixel] = img[pixel] <= threshold(pixel) ? 0 : 1
    end

    return out
end

(f::Niblack)(out::GenericGrayImage, img::AbstractArray{<:Color3},
             args...; kwargs...) =
    f(out, of_eltype(Gray, img), args...; kwargs...)

# keep consistent to default_AdaptiveThreshold_window_size
# TODO: infer a better window_size from `img` rather than using fixed number
default_Niblack_window_size(img) = 7
