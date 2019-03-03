"""
```
binarize(AdaptiveThreshold(), img; t, s)
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

## Choices for `t`
You can specify an interger for `t` between 0 and 100.

## Choices for `s`
The argument `s` specifies the size of pixel's square neighbourhood which must be
greater than zero. A recommended size is the integer value which is
closest to 1/8 of the average of the width and height. You can use
the convenience function `recommend_size(::AbstractArray{T,2})` to obtain this
suggested value.

#Example

```julia
using TestImages

img = testimage("cameraman")

binarize(AdaptiveThreshold(),img,15,80)
binarize(AdaptiveThreshold(),img,15,80)
```

# References
[1] Bradley, D. (2007). Adaptive Thresholding using Integral Image. Journal of Graphic Tools, 12(2), pp.13-21.
"""
function binarize(algorithm::AdaptiveThreshold, img::AbstractArray{T,2}; t::Int, s::Int) where T <: Colorant
    binarize(algorithm, Gray.(img),t = t, s = s)
end

function binarize(algorithm::AdaptiveThreshold, img::AbstractArray{T,2}; t::Int = 15, s::Int = 15) where T <: Gray
    if s < 0 || t < 0 || t > 100
        return error("s and t must be greater than or equal to 0. t must be less than equal 100")
    end
    img₀₁ = zeros(Gray{Bool}, axes(img))
    integral_img = Images.integral_image(img)
    w = size(img)[2]
    h = size(img)[1]
    for i in CartesianIndices(img)
        j,k = i.I
        y1 = max(1,j - div(s,2))
        y2 = min(h,j + div(s,2))
        x1 = max(1,k - div(s,2))
        x2 = min(w,k + div(s,2))
        total = Images.boxdiff(integral_img, y1:y2, x1:x2)
        count = (y2-y1)*(x2-x1)
        if img[i]*count <= total*((100-t)/100)
            img₀₁[i]=0
        else
            img₀₁[i]=1
        end
    end
    img₀₁
end


function recommend_size(img::AbstractArray)
    s = div(div((size(img)[2]+size(img)[1]),2),8)
end
