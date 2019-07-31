"""
    Intermodes <: AbstractImageBinarizationAlgorithm
    Intermodes()

    binarize([T,] img, f::AdaptiveThreshold; [window_size])
    binarize!([out,] img, f::AdaptiveThreshold; [window_size])


Under the assumption that the image histogram is bimodal the image histogram is
smoothed using a length-3 mean filter until two modes remain. The binarization
threshold is then set to the average value of the two modes.

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
img_binary = binarize(img, Intermodes())
```

## Reference

1. C. A. Glasbey, “An Analysis of Histogram-Based Thresholding Algorithms,” CVGIP: Graphical Models and Image Processing, vol. 55, no. 6, pp. 532–537, Nov. 1993. [doi:10.1006/cgip.1993.1040](https://doi.org/10.1006/cgip.1993.1040)
"""
struct Intermodes <: AbstractImageBinarizationAlgorithm end

function (f::Intermodes)(out::GenericGrayImage, img::GenericGrayImage)
    edges, counts = build_histogram(img,  256)
    t = find_threshold(HistogramThresholding.Intermodes(), counts[1:end], edges)
    @simd for i in CartesianIndices(img)
      out[i] = img[i] < t ? 0 : 1
    end
    out
end

(f::Intermodes)(out::GenericGrayImage, img::AbstractArray{<:Color3}) =
    f(out, of_eltype(Gray, img))
