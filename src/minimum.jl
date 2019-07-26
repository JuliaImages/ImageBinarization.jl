"""
    MinimumIntermodes <: AbstractImageBinarizationAlgorithm
    MinimumIntermodes()

    binarize([T,] img, f::MinimumIntermodes)
    binarize!([out,] img, f::MinimumIntermodes)

Under the assumption that the image histogram is bimodal the histogram is
smoothed using a length-3 mean filter until two modes remain. The binarization
threshold is then set to the minimum value between the two modes.

# Output

Return the binarized image as an `Array{Gray{T}}` of size `size(img)`. If
`T` is not specified, it is inferred from `out` and `img`.

# Arguments

The function argument is described in more detail below.

##  `img::AbstractArray`

The image that needs to be binarized. The image is automatically converted
to `Gray` in order to construct the requisite graylevel histogram.

# Example

Binarize the "cameraman" image in the `TestImages` package.

```julia
using TestImages, ImageBinarization

img = testimage("cameraman")
img_binary = binarize(img, MinimumIntermodes())
```

# Reference

1. C. A. Glasbey, “An Analysis of Histogram-Based Thresholding Algorithms,” *CVGIP: Graphical Models and Image Processing*, vol. 55, no. 6, pp. 532–537, Nov. 1993. [doi:10.1006/cgip.1993.1040](https://doi.org/10.1006/cgip.1993.1040)
2. J. M. S. Prewitt and M. L. Mendelsohn, “THE ANALYSIS OF CELL IMAGES*,” *Annals of the New York Academy of Sciences*, vol. 128, no. 3, pp. 1035–1053, Dec. 2006. [doi:10.1111/j.1749-6632.1965.tb11715.x](https://doi.org/10.1111/j.1749-6632.1965.tb11715.x)
"""
struct MinimumIntermodes <: AbstractImageBinarizationAlgorithm end

function (f::MinimumIntermodes)(out::GenericGrayImage, img::GenericGrayImage)
    edges, counts = build_histogram(img,  256)
    t = find_threshold(HistogramThresholding.MinimumIntermodes(), counts[1:end], edges)
    @simd for i in CartesianIndices(img)
        out[i] = img[i] < t ? 0 : 1
    end
    out
end

(f::MinimumIntermodes)(out::GenericGrayImage, img::AbstractArray{<:Color3}) =
    f(out, of_eltype(Gray, img))
