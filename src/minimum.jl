"""
```
binarize(MinimumIntermodes(), img)
```

Under the assumption that the image histogram is bimodal the histogram is
smoothed using a length-3 mean filter until two modes remain. The binarization
threshold is then set to the minimum value between the two modes.

# Output

Returns the binarized image as an `Array{Gray{Bool},2}`.

# Arguments

The function argument is described in more detail below.

##  `img`

An `AbstractArray` representing an image. The image is automatically converted
to `Gray` in order to construct the requisite graylevel histogram.

# Example

Binarize the "cameraman" image in the `TestImages` package.

```julia
using TestImages, ImageBinarization

img = testimage("cameraman")
img_binary = binarize(MinimumIntermodes(), img)
```

# Reference

1. C. A. Glasbey, “An Analysis of Histogram-Based Thresholding Algorithms,” *CVGIP: Graphical Models and Image Processing*, vol. 55, no. 6, pp. 532–537, Nov. 1993. [doi:10.1006/cgip.1993.1040](https://doi.org/10.1006/cgip.1993.1040)
2. J. M. S. Prewitt and M. L. Mendelsohn, “THE ANALYSIS OF CELL IMAGES*,” *Annals of the New York Academy of Sciences*, vol. 128, no. 3, pp. 1035–1053, Dec. 2006. [doi:10.1111/j.1749-6632.1965.tb11715.x](https://doi.org/10.1111/j.1749-6632.1965.tb11715.x)
"""
function binarize(algorithm::MinimumIntermodes,  img::AbstractArray{T,2}) where T <: Colorant
    img₀₁ = zeros(Gray{Bool}, axes(img))
    edges, counts = build_histogram(img,  256)
    t = find_threshold(HistogramThresholding.MinimumIntermodes(), counts[1:end], edges)
    for i in CartesianIndices(img)
      img₀₁[i] = img[i] < t ? 0 : 1
    end
    img₀₁
end
