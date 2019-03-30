@doc raw"""
    Moments()

Constructs an instance of `Moments` image binarization algorithm.

The following rule determines the binarization threshold:  if one assigns all
observations below the threshold to a value z₀ and all observations above the
threshold to a value z₁, then the first three moments of the original histogram
must match the moments of this specially constructed bilevel histogram.

# Details

Let ``f_i`` ``(i=1 \ldots I)`` denote the number of observations in the
``i``th bin of the histogram and ``z_i`` ``(i=1 \ldots I)`` the observed value
associated with the ``i``th bin.  Then the probability that an observation ``z_i``
belongs to the ``i``th bin is given by  ``p_i = \frac{f_i}{N}`` (``i = 1,
\ldots, I``), where ``N = \sum_{i=1}^{I}f_i``.

Moments can be computed from the histogram ``f`` in the following way:

```math
m_k = \frac{1}{N} \sum_i p_i (z_i)^k \quad k = 0,1,2,3, \ldots.
```
The principle of moment-preserving thresholding is to select a threshold value,
as well as two representative values ``z_0`` and ``z_1`` (``z_0 < z_1``),
such that if all below-threshold values in ``f`` are replaced by ``z_0`` and
all above-threshold values are replaced by ``z_1``, then this specially constructed
bilevel histogram ``g`` will have the same first three moments as ``f``.

Concretely, let ``q_0`` and ``q_1`` denote the fractions of observations below
and above the threshold in ``f``, respectively. The constraint that the first
three moments in ``g`` must equal the first three moments in ``f`` can be
expressed by the following system of four equations

```math
\begin{aligned}
   q_0 (z_0)^0 + q_1 (z_1)^0   & = m_0 \\
   q_0 (z_0)^1 + q_1 (z_1)^1   & = m_1 \\
   q_0 (z_0)^2 + q_1 (z_1)^2   & = m_2 \\
   q_0 (z_0)^3 + q_1 (z_1)^3   & = m_3 \\
\end{aligned}
```
where the left-hand side represents the moments of ``g`` and the right-hand side
represents the moments of ``f``. To find the desired treshold value, one first solves
the four equations to obtain ``q_0`` and ``q_1``, and then chooses the threshold
``t`` such that ``q_0 = \sum_{z_i \le t} p_i``.

# Reference

1. W.-H. Tsai, “Moment-preserving thresolding: A new approach,” *Computer Vision, Graphics, and Image Processing*, vol. 29, no. 3, pp. 377–393, Mar. 1985. [doi:10.1016/0734-189x(85)90133-1](https://doi.org/10.1016/0734-189x%2885%2990133-1)

See also: [`binarize`](@ref ImageBinarization.binarize), [`BinarizationAlgorithm`](@ref ImageBinarization.BinarizationAlgorithm)
"""
struct Moments <: BinarizationAlgorithm end


"""
    binarize(algorithm::Moments,  img::AbstractArray{T,2}) where T <: Colorant

Binarizes the image using `Moments` histogram thresholding method.

The following rule determines the binarization threshold:  if one assigns all
observations below the threshold to a value z₀ and all observations above the
threshold to a value z₁, then the first three moments of the original histogram
must match the moments of this specially constructed bilevel histogram.

Check [`Moments`](@ref ImageBinarization.Moments) for more details.
"""
function binarize(algorithm::Moments,  img::AbstractArray{T,2}) where T <: Colorant
  img₀₁ = zeros(Gray{Bool}, axes(img))
  edges, counts = build_histogram(img,  256)
  t = find_threshold(HistogramThresholding.Moments(), counts[1:end], edges)
  for i in CartesianIndices(img)
    img₀₁[i] = img[i] < t ? 0 : 1
  end
  img₀₁
end
