"""
```
imgb = binarize(Yen(), img)
binarize!(Yen(), img)
```

Uses Yen's maximum correlation criterion to threshold the histogram of a given
image.

# Arguments

The function arguments are described in more detail below.

##  `img`

An `AbstractGray` image which is to be binarized into background (`Gray(0)`)
and foreground (`Gray(1)`) pixels.

## Reference

Yen JC, Chang FJ, Chang S (1995), "A New Criterion for Automatic Multilevel Thresholding", IEEE Trans. on Image Processing 4 (3): 370-378, [doi:10.1109/83.366472](https://doi.org/10.1109/83.366472)
"""
function binarize(algorithm::Yen,  img::AbstractArray{T,2}) where T <: AbstractGray
  binarize!(algorithm, copy(img))
end


"""
```
t = binarize!(Yen(), img)
```
Same as [`binarize`](@ref binarize(::Yen, ::AbstractArray{<:AbstractGray,2})) except that it modifies the image that was passed as an argument.
"""
function binarize!(algorithm::Yen,  img::AbstractArray{T,2}) where T <: AbstractGray
  edges, counts = build_histogram(img,  256)
  t = find_threshold(HistogramThresholding.Yen(), counts[1:end], edges)
  map!(img,img) do val
    val < t ? Gray(0) : Gray(1)
  end
end
