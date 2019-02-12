"""
```
imgb = binarize(Otsu(), img)
binarize!(Otsu(), img)
```

Under the assumption that the histogram is bimodal the threshold is
set so that the resultant inter-class variance is maximal.

# Arguments

The function arguments are described in more detail below.

##  `img`

An `AbstractGray` image which is to be binarized into background (`Gray(0)`)
and foreground (`Gray(1)`) pixels.

## Reference

Nobuyuki Otsu (1979). "A threshold selection method from gray-level histograms". *IEEE Trans. Sys., Man., Cyber.* 9 (1): 62–66. [doi:10.1109/TSMC.1979.4310076](http://dx.doi.org/doi:10.1109/TSMC.1979.4310076)
"""
function binarize(algorithm::Otsu,  img::AbstractArray{T,2}) where T <: AbstractGray
  binarize!(algorithm, copy(img))
end


"""
```
t = binarize!(Otsu(), img)
```
Same as [`binarize`](@ref binarize(::Otsu, ::AbstractArray{<:AbstractGray,2})) except that it modifies the image that was passed as an argument.
"""
function binarize!(algorithm::Otsu,  img::AbstractArray{T,2}) where T <: AbstractGray
  edges, counts = build_histogram(img,  256)
  t = find_threshold(HistogramThresholding.Otsu(), counts[1:end], edges)
  map!(img,img) do val
    val < t ? Gray(0) : Gray(1)
  end
end
