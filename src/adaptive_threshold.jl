"""
```
imageb = binarize(AdaptiveThreshold(), img, t, s)
imageb = binarize(AdaptiveThreshold(), img, t)
```

Adaptively thresholds and binarises and image using the integral image.
Automatically converts image to grayscale.

# Output

Returns a binarized grayscale image which is an `AbstractArray`. In partiular
the each value in Array{Gray} contains only either 0.0 or 1.0

# Details

This is an algorithm designed to threshold and binarise an image automatically
based on the arguments passed to the function. This algorithm specialises in
binarizing images that have intense or dynamic shadowing (e.g live images,
photographs, old documents etc.). This algorithm specializes in binarizing t
works particularly well on images that have distint contrast between background
and foreground. See (Bradley, 2007) for more details

`img::AbstractArray` - A grayscale image in the format of an array. All the
values in the array while be binarize to either Gray(0) or Gray(1)

`t::Int` - Threshold value as a percentage. If the current pixel value is t %
lower than the moving average (see Bradley, 2007 for more details) then the
output pixel is set too black. Otherwise the output is white. Recommended ~
10-15 to start with. Note Default value for all tests is 15

`s::Int` - The size of the threshold square (of pixels) which allows the
algorithm to adaptively calculte the threshold value using the integral image
and a moving average(more details see Bradley, 2007). A recommended starting
point is the integer value which is closest to 1/8 of the average of the width
and height. The function defualts to this if s is not specified (see function 2)

`t` and `s` should be experimented with to suit individual user needs

# Options
Various options for the parameters of this function are described in more detail
below.

## Choices for `t`
You can specify an interger for `t` between 0 & 100. If you specify an integer
outside of this range, the function will return an error.

## Choices for `s`
You can specify an integer for `s` that is greater than 0. If you specify an
integer that is negative the function will return an error

#Example

```julia
using TestImages

img = testimage("cameraman")

binarize(AdaptiveThreshold(),img,15)
binarize(AdaptiveThreshold(),img,15,80)
```

# References
[1] Bradley, D. (2007). Adaptive Thresholding using Integral Image. Journal of Graphic Tools, 12(2), pp.13-21.
"""

#(1)
function binarize(algorithm::AdaptiveThreshold, img::AbstractArray{T}, t::Int, s::Int) where T <: Gray
    if s < 0 || t < 0 || t > 100
        return error("s and t must be greater than or equal to 0. t must be less than equal 100")
    end
    integral_img = Images.integral_image(img)
    output_img = copy(img)
    w = size(img)[2]
    h = size(img)[1]
    for i in CartesianIndices(img)
        j,k = i.I
        y1 = max(1,j-div(s,2))
        y2 = min(h,j+div(s,2))
        x1 = max(1,k-div(s,2))
        x2 = min(w,k+div(s,2))
        total = Images.boxdiff(integral_img, y1:y2, x1:x2)
        count = (y2-y1)*(x2-x1)
        if img[i]*count <= total*((100-t)/100)
            output_img[i]=0
        else
            output_img[i]=1
        end
    end
    output_img
end

#(2) call (1)
#function with no s specified
function binarize(algorithm::AdaptiveThreshold, img::AbstractArray{T}, t::Int) where T <: Gray
    binarize(AdaptiveThreshold(),img,t,get_s(img))
end

#(3) calls (1)
function binarize(algorithm::AdaptiveThreshold, img::AbstractArray{T}, t::Int, s::Int) where T <: Colorant
    working_img = Gray.(img)
    binarize(AdaptiveThreshold(),working_img,t,s)
end

#(4) calls (3)
function binarize(algorithm::AdaptiveThreshold, img::AbstractArray{T}, t::Int) where T <: Colorant
    binarize(AdaptiveThreshold(),img,t,get_s(img))
end


"""
```
binarize!(AdaptiveThreshold(),img, t, s)
binarize!(AdaptiveThreshold(),img, t)
```

Varient of the binarize(AdaptiveThreshold(), ....) function which mutates the
img argument. See ['binarize(AdaptiveThreshold(), ...)'](@ref binarize(::AdaptiveThreshold, ::AbstractArray{T}, ::Int, ::Int) where T <: AbstractGray) for more details
"""

#(5) calls (1)
#function mutates the argument img
function binarize!(algorithm::AdaptiveThreshold, img::AbstractArray{T}, t::Int, s::Int) where T <: Gray
    output_img = binarize(AdaptiveThreshold(), img, t, s)
    for i in CartesianIndices(img)
        img[i] = output_img[i]
    end
end

#(6) calls (5)
#function mutates the argument img with no s specified
function binarize!(algorithm::AdaptiveThreshold, img::AbstractArray{T}, t::Int) where T <: Gray
    binarize!(AdaptiveThreshold(),img,t,get_s(img))
end

#(7) calls (3)
function binarize!(algorithm::AdaptiveThreshold, img::AbstractArray{T}, t::Int, s::Int) where T <: Colorant
    output_img = binarize(AdaptiveThreshold(),img,t,s)
    for i in CartesianIndices(img)
        img[i] = output_img[i]
    end
end

#(8) calls (7)
function binarize!(algorithm::AdaptiveThreshold, img::AbstractArray{T}, t::Int) where T <: Colorant
    binarize!(AdaptiveThreshold(),img,t,get_s(img))
end

#utility function for AdaptiveThreshold
function get_s(img::AbstractArray)
    s = div(div((size(img)[2]+size(img)[1]),2),8)
    s
end
