"""
```
imgb = binarize(MinimumIntermodes(), img)
binarize!(MinimumIntermodes(), img)
```

nder the assumption that the histogram is bimodal the images histogram is
iterativly smoothed untill two modes remain. The threshold is then set to the
minimum value between the two thresholds. Falls back on
`HistogramThresholding.UnimodalRosin()` if only one mode is found.

# Arguments

The function arguments are described in more detail below.

##  `img`

An `AbstractGray` image which is to be binarized into background (`Gray(0)`)
and foreground (`Gray(1)`) pixels.

## Reference

1. C. A. Glasbey, “An Analysis of Histogram-Based Thresholding Algorithms,” *CVGIP: Graphical Models and Image Processing*, vol. 55, no. 6, pp. 532–537, Nov. 1993. [doi:10.1006/cgip.1993.1040](https://doi.org/10.1006/cgip.1993.1040)
2. J. M. S. Prewitt and M. L. Mendelsohn, “THE ANALYSIS OF CELL IMAGES*,” *Annals of the New York Academy of Sciences*, vol. 128, no. 3, pp. 1035–1053, Dec. 2006. [doi:10.1111/j.1749-6632.1965.tb11715.x](https://doi.org/10.1111/j.1749-6632.1965.tb11715.x)
"""
function binarize(algorithm::MinimumIntermodes,  img::AbstractArray{T,2}) where T <: AbstractGray
  binarize!(algorithm, copy(img))
end

function binarize!(algorithm::MinimumIntermodes,  img::AbstractArray{T,2}) where T <: AbstractGray
  edges, counts = build_histogram(img,  256)
  t = find_threshold(HistogramThresholding.MinimumIntermodes(), counts[1:end], edges)
  map!(img,img) do val
    val < t ? Gray(0) : Gray(1)
  end
end
