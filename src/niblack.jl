"""
```
img_bin = binarize(Niblack(), img, w = 7, k = 0.2)
```

Applies Niblack adaptive thresholding [1] under the assumption that the input
image is textual.

# Parameters

## `img`

An `AbstractGray` image, which is binarized according to a per-pixel adaptive
threshold into background (`Gray(0)`) and foreground (`Gray(1)`) pixel values.

## `w`

The threshold for each pixel is a function of the distribution of the intensities
of all neighboring pixels in a square window around it. The side length of this
window is `2*w + 1`, with the target pixel in the center position.

## `k`

A user-defined biasing parameter. This can take negative values.

# Output

Returns an AbstractArray{T,2} where T is the element type of the input image,
representing a binarized copy of the input image.

# Details

The input image is binarized by varying the threshold across the image, using
a modified version of Niblack's algorithm [2]. A threshold ``T`` is defined for
each pixel based on the mean ``m`` and standard deviation ``s`` of the
intensities of neighboring pixels in a window around it. This threshold is given
by

```math
T(x,y) = m(x,y) + k \\cdot s(x,y),
```

where ``k`` is a user-defined parameter weighting the influence of the standard
deviation on the value of ``T``.

Note that Niblack's algorithm is highly sensitive to variations in the gray
values of background pixels, which often exceed local thresholds and appear as
artifacts in the binarized image. The Sauvola algorithm included in this package
implements an attempt to address this issue [2].

# References

[1] Wayne Niblack (1986). *An Introduction to Image Processing*. Prentice-Hall, Englewood Cliffs, NJ: 115-16.
[2] J. Sauvola and M. Pietikäinen (2000). "Adaptive document image binarization". *Pattern Recognition* 33 (2): 225-236. [doi:10.1016/S0031-3203(99)00055-2](https://doi.org/10.1016/S0031-3203(99)00055-2)
"""
function binarize(algorithm::Niblack, img::AbstractArray{T,2}; w::Integer = 7,
                  k::Real = 0.2) where T <: AbstractGray
    binarize!(algorithm, copy(img), w=w, k=k)
end

"""
```
img_bin = binarize!(Niblack(), img, w = 7, k = 0.2)
```
Same as [`binarize`](@ref binarize(::Niblack, ::AbstractArray{<:AbstractGray,2}; ::Integer, ::Real))
except that it modifies the image that was passed as an argument.
"""
function binarize!(algorithm::Niblack, img::AbstractArray{T,2}; w::Integer = 7,
                   k::Real = 0.2) where T <: AbstractGray
    img_raw = channelview(img)
    I = integral_image(img_raw)
    I² = integral_image(img_raw.^2)

    function threshold(pixel::CartesianIndex{2})
        row₀, col₀, row₁, col₁ = get_window_bounds(img, pixel, w)
        m = μ_in_window(I, row₀, col₀, row₁, col₁)
        s = σ_in_window(I², m, row₀, col₀, row₁, col₁)
        return m + (k * s)
    end

    for pixel in CartesianIndices(img)
        img[pixel] = img[pixel] <= threshold(pixel) ? Gray(0) : Gray(1)
    end

    return img
end
