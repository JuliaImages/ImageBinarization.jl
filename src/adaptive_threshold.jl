

"""
```
binarize(AdaptiveThreshold(; percentage = 15, window_size = 32), img)
```
Uses a binarization threshold that varies across the image according
to background illumination.

# Output

Returns the binarized image as an `Array{Gray{Bool},2}`.

# Details

If the value of a pixel is ``t`` percent less than the  average of an ``s
\\times s`` window of pixels centered around the pixel, then the pixel is set
to black, otherwise it is set to white.

A computationally efficient method for computing the average of an ``s \\times s``
neighbourhood is achieved by using an *integral image*.

This algorithm works particularly well on images that have distinct contrast
between background and foreground. See [1] for more details.

# Options
Various options for the parameters of this function are described in more detail
below.

## Choices for `percentage`
You can specify an integer for the `percentage` (denoted by ``t`` in the
publication) which must be between 0 and 100. If left unspecified a default
value of 15 is utilised.

## Choices for `window_size`
The argument `window_size` (denoted by ``s`` in the publication)  specifies the
size of pixel's square neighbourhood which must be greater than zero. A
recommended size is the integer value which is closest to 1/8 of the average of
the width and height. You can use the convenience function
`recommend_size(::AbstractArray{T,2})` to obtain this suggested value.
If left unspecified, a default value of 32 is utilised.

#Example

```julia
using TestImages

img = testimage("cameraman")
s = recommend_size(img)
binarize(AdaptiveThreshold(percentage = 15, window_size = s), img)
```

# References
1. Bradley, D. (2007). Adaptive Thresholding using Integral Image. *Journal of Graphic Tools*, 12(2), pp.13-21. [doi:10.1080/2151237x.2007.10129236](https://doi.org/10.1080/2151237x.2007.10129236)
"""
function binarize(algorithm::AdaptiveThreshold, img::AbstractArray{T,2}) where T <: Colorant
    binarize(algorithm, Gray.(img))
end

function binarize(algorithm::AdaptiveThreshold, img::AbstractArray{T,2}) where T <: Gray
    s = algorithm.window_size
    t = algorithm.percentage
    if s < 0 || t < 0 || t > 100
        return error("Percentage and window_size must be greater than or equal to 0. Percentage must be less than or equal to 100.")
    end
    img₀₁ = zeros(Gray{Bool}, axes(img))
    integral_img = integral_image(img)
    h, w = size(img)
    for i in CartesianIndices(img)
        j,k = i.I
        y1 = max(1,j - div(s,2))
        y2 = min(h,j + div(s,2))
        x1 = max(1,k - div(s,2))
        x2 = min(w,k + div(s,2))
        total = boxdiff(integral_img, y1:y2, x1:x2)
        count = (y2 - y1) * (x2 - x1)
        if img[i] * count <= total * ((100 - t) / 100)
            img₀₁[i] = 0
        else
            img₀₁[i] = 1
        end
    end
    img₀₁
end

AdaptiveThreshold(; percentage::Int = 15, window_size::Int = 32) = AdaptiveThreshold(percentage, window_size)

"""
```
recommend_size(img)
```
Helper function for `AdaptiveThreshold` algorithm which returns an integer value
which is closest to 1/8 of the average of the width and height of the image.
"""
function recommend_size(img::AbstractArray{T,2}) where T
    s = div(div(sum(size(img)),2),8)
end
