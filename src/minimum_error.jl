"""
```
t = binarize(MinimumError(), img)
```

Under the assumption that the histogram is a mixture of two Gaussian
distributions the threshold is chosen such that the expected misclassification
error rate is minimised.

# Arguments

The function arguments are described in more detail below.

## `img`

An `AbstractGray` image which is to be binarized into background (`Gray(0)`)
and foreground (`Gray(1)`) pixels.

## References

1. J. Kittler and J. Illingworth, “Minimum error thresholding”, Pattern Recognition, vol. 19, no. 1, pp. 41–47, Jan. 1986. [doi:10.1016/0031-3203(86)90030-0](https://doi.org/10.1016/0031-3203%2886%2990030-0)
2. Q.-Z. Ye and P.-E. Danielsson, “On minimum error thresholding and its implementations”, Pattern Recognition Letters, vol. 7, no. 4, pp. 201–206, Apr. 1988. [doi:10.1016/0167-8655(88)90103-1](https://doi.org/10.1016/0167-8655%2888%2990103-1)
"""
function binarize(algorithm::MinimumError, img::AbstractArray{T,2}) where T <: AbstractGray
    binarize!(algorithm, copy(img))
end

"""
```
t = binarize!(MinimumError(), img)
```
Same as [`binarize`](@ref binarize(::MinimumError, ::AbstractArray{<:AbstractGray,2})) except that it modifies the image that was passed as an argument.
"""
function binarize!(algorithm::MinimumError, img::AbstractArray{T,2}) where T <: AbstractGray
    edges, counts = build_histogram(img, 256)
    t = find_threshold(HistogramThresholding.MinimumError(), counts[1:end], edges)
    map!(img,img) do val
        val < t ? Gray(0) : Gray(1)
    end
end
