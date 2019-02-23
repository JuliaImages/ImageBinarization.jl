"""
```
imgb = binarize(Balanced(), img)
binarize!(Balanced(), img)
```

By balancing both side of the images histogram the threshold is iterativly
updated to balance both by removing a bin untill sides untill converge to a value.

# Arguments

The function arguments are described in more detail below.

##  `img`

An `AbstractGray` image which is to be binarized into background (`Gray(0)`)
and foreground (`Gray(1)`) pixels.

## Reference

"BI-LEVEL IMAGE THRESHOLDING - A Fast Method", Proceedings of the First International Conference on Bio-inspired Systems and Signal Processing, 2008. Available: [10.5220/0001064300700076](https://doi.org/10.5220/0001064300700076)
"""
function binarize(algorithm::Balanced,  img::AbstractArray{T,2}) where T <: AbstractGray
  binarize!(algorithm, copy(img))
end


"""
```
t = binarize!(Balanced(), img)
```
Same as [`binarize`](@ref binarize(::Balanced, ::AbstractArray{<:AbstractGray,2})) except that it modifies the image that was passed as an argument.
"""
function binarize!(algorithm::Balanced,  img::AbstractArray{T,2}) where T <: AbstractGray
  edges, counts = build_histogram(img,  256)
  t = find_threshold(HistogramThresholding.Balanced(), counts[1:end], edges)
  map!(img,img) do val
    val < t ? Gray(0) : Gray(1)
  end
end
