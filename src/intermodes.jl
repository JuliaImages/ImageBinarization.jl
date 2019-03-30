"""
    Intermodes()

Constructs an instance of `Intermodes` image binarization algorithm.

Under the assumption that the image histogram is bimodal the image histogram is
smoothed using a length-3 mean filter until two modes remain. The binarization
threshold is then set to the average value of the two modes.

## Reference

1. C. A. Glasbey, “An Analysis of Histogram-Based Thresholding Algorithms,” *CVGIP: Graphical Models and Image Processing*, vol. 55, no. 6, pp. 532–537, Nov. 1993. [doi:10.1006/cgip.1993.1040](https://doi.org/10.1006/cgip.1993.1040)
"""
struct Intermodes <: BinarizationAlgorithm end


"""
    binarize(algorithm::Intermodes,  img::AbstractArray{T,2}) where T <: Colorant

Binarizes the image using `Intermodes` histogram thresholding method.

Under the assumption that the image histogram is bimodal the image histogram is
smoothed using a length-3 mean filter until two modes remain. The binarization
threshold is then set to the average value of the two modes.

Check [`Intermodes`](@ref ImageBinarization.Intermodes) for more details.
"""
function binarize(algorithm::Intermodes,  img::AbstractArray{T,2}) where T <: Colorant
  img₀₁ = zeros(Gray{Bool}, axes(img))
  edges, counts = build_histogram(img,  256)
  t = find_threshold(HistogramThresholding.Intermodes(), counts[1:end], edges)
  for i in CartesianIndices(img)
    img₀₁[i] = img[i] < t ? 0 : 1
  end
  img₀₁
end
