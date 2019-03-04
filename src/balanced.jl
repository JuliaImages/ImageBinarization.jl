@doc raw"""
```
binarize(Balanced(), img)
```
Binarizes the image using the balanced histogram thresholding method.

# Output

Returns the binarized image as an `Array{Gray{Bool},2}`.

# Details
In balanced histogram thresholding, one interprets a  bin as a  physical weight
with a mass equal to its occupancy count. The balanced histogram method involves
iterating the following three steps: (1) choose the midpoint bin index as a
"pivot",  (2) compute the combined weight to the left and right of the pivot bin
and (3) remove the leftmost bin if the left side is the heaviest, and the
rightmost bin otherwise. The algorithm stops when only a single bin remains. The
last bin determines the sought-after threshold with which the image is
binarized.

Let ``f_n`` (``n = 1 \ldots N``) denote the number of observations in the ``n``th
bin of the image histogram. The balanced histogram method constructs a sequence
of nested intervals

```math
[1,N] \cap \mathbb{Z} \supset I_2 \supset I_3 \supset \ldots \supset I_{N-1},
```
where for ``k = 2 \ldots N-1``
```math
I_k = \begin{cases}
   I_{k-1} \setminus \{\min \left( I_{k-1} \right) \} &\text{if } \sum_{n = \min \left( I_{k-1} \right)}^{I_m}f_n \gt   \sum_{n =  I_m + 1}^{ \max \left( I_{k-1} \right)} f_n, \\
   I_{k-1} \setminus \{\max \left( I_{k-1} \right) \} &\text{otherwise},
\end{cases}
```
and ``I_m = \lfloor \frac{1}{2}\left(  \min \left( I_{k-1} \right) +  \max \left( I_{k-1} \right) \right) \rfloor ``.
The final interval ``I_{N-1}`` consists of a single element which is the bin index
corresponding to the desired threshold.

If one interprets a bin as a physical weight with a mass equal to its occupancy
count, then each step of the algorithm can be conceptualised as removing the
leftmost or rightmost bin to "balance" the resulting histogram on a pivot. The
pivot is defined to be the midpoint between the start and end points of the
interval under consideration.

If it turns out that the single element in ``I_{N-1}`` equals ``1`` or ``N`` then
the original histogram must have a single peak and the algorithm has failed to
find a suitable threshold. In this case the algorithm will fall back to using
the `UnimodalRosin` method to select the threshold.


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
img_binary = binarize(Balanced(), img)
```

# Reference

1. “BI-LEVEL IMAGE THRESHOLDING - A Fast Method”, Proceedings of the First International Conference on Bio-inspired Systems and Signal Processing, 2008. Available: [10.5220/0001064300700076](https://doi.org/10.5220/0001064300700076)
"""
function binarize(algorithm::Balanced,  img::AbstractArray{T,2}) where T <: Colorant
    img₀₁ = zeros(Gray{Bool}, axes(img))
    edges, counts = build_histogram(img,  256)
    t = find_threshold(HistogramThresholding.Balanced(), counts[1:end], edges)
    for i in CartesianIndices(img)
      img₀₁[i] = img[i] < t ? 0 : 1
    end
    img₀₁
end
