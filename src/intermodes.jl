"""
```
imgb = binarize(Intermodes(), img)
binarize!(Intermodes(), img)
```

Under the assumption that the histogram is bimodal the images histogram is
iterativly smoothed untill two modes remain. The threshold is then set to the
average value of the two thresholds. Falls back on
`HistogramThresholding.UnimodalRosin()` if only one mode is found.

# Arguments

The function arguments are described in more detail below.

##  `img`

An `AbstractGray` image which is to be binarized into background (`Gray(0)`)
and foreground (`Gray(1)`) pixels.

## Reference

C. A. Glasbey, “An Analysis of Histogram-Based Thresholding Algorithms,” CVGIP: Graphical Models and Image Processing, vol. 55, no. 6, pp. 532–537, Nov. 1993. [doi:10.1006/cgip.1993.1040](https://doi.org/10.1006/cgip.1993.1040)
"""
function binarize(algorithm::Intermodes,  img::AbstractArray{T,2}) where T <: AbstractGray
  binarize!(algorithm, copy(img))
end

function binarize!(algorithm::Intermodes,  img::AbstractArray{T,2}) where T <: AbstractGray
  edges, counts = build_histogram(img,  256)
  t = find_threshold(HistogramThresholding.Intermodes(), counts[1:end], edges)
  map!(img,img) do val
    val < t ? Gray(0) : Gray(1)
  end
end
