#=
Copied from https://github.com/JuliaImages/Images.jl/blob/master/src/algorithms.jl
to ensure that this package doesn't need to depend on Images.jl.
In future the intergral image code should be its own package.
Work in this direction already started here:
https://github.com/JuliaImages/IntegralArrays.jl
=#

"""
```
integral_img = integral_image(img)
```
Returns the integral image of an image. The integral image is calculated by assigning
to each pixel the sum of all pixels above it and to its left, i.e. the rectangle from
(1, 1) to the pixel. An integral image is a data structure which helps in efficient
calculation of sum of pixels in a rectangular subset of an image. See `boxdiff` for more
information.
"""
function integral_image(img::AbstractArray)
    integral_img = Array{accum(eltype(img))}(undef, size(img))
    sd = coords_spatial(img)
    cumsum!(integral_img, img, dims=sd[1])
    for i = 2:length(sd)
        cumsum!(integral_img, integral_img, dims=sd[i])
    end
    integral_img
end

"""
```
sum = boxdiff(integral_image, ytop:ybot, xtop:xbot)
sum = boxdiff(integral_image, CartesianIndex(tl_y, tl_x), CartesianIndex(br_y, br_x))
sum = boxdiff(integral_image, tl_y, tl_x, br_y, br_x)
```
An integral image is a data structure which helps in efficient calculation of sum of pixels in
a rectangular subset of an image. It stores at each pixel the sum of all pixels above it and to
its left. The sum of a window in an image can be directly calculated using four array
references of the integral image, irrespective of the size of the window, given the `yrange` and
`xrange` of the window. Given an integral image -
        A - - - - - - B -
        - * * * * * * * -
        - * * * * * * * -
        - * * * * * * * -
        - * * * * * * * -
        - * * * * * * * -
        C * * * * * * D -
        - - - - - - - - -
The sum of pixels in the area denoted by * is given by S = D + A - B - C.
"""
boxdiff(int_img::AbstractArray{T, 2}, y::UnitRange, x::UnitRange) where {T} = boxdiff(int_img, y.start, x.start, y.stop, x.stop)
boxdiff(int_img::AbstractArray{T, 2}, tl::CartesianIndex, br::CartesianIndex) where {T} = boxdiff(int_img, tl[1], tl[2], br[1], br[2])

function boxdiff(int_img::AbstractArray{T, 2}, tl_y::Integer, tl_x::Integer, br_y::Integer, br_x::Integer) where T
    sum = int_img[br_y, br_x]
    sum -= tl_x > 1 ? int_img[br_y, tl_x - 1] : zero(T)
    sum -= tl_y > 1 ? int_img[tl_y - 1, br_x] : zero(T)
    sum += tl_y > 1 && tl_x > 1 ? int_img[tl_y - 1, tl_x - 1] : zero(T)
    sum
end


accum(::Type{T}) where {T<:Integer} = Int
accum(::Type{Float32})    = Float32
accum(::Type{T}) where {T<:Real} = Float64
accum(::Type{C}) where {C<:Colorant} = base_colorant_type(C){accum(eltype(C))}
