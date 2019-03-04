var documenterSearchIndex = {"docs": [

{
    "location": "#",
    "page": "ImageBinarization.jl Documentation",
    "title": "ImageBinarization.jl Documentation",
    "category": "page",
    "text": ""
},

{
    "location": "#ImageBinarization.jl-Documentation-1",
    "page": "ImageBinarization.jl Documentation",
    "title": "ImageBinarization.jl Documentation",
    "category": "section",
    "text": "Depth = 3"
},

{
    "location": "#Functions-1",
    "page": "ImageBinarization.jl Documentation",
    "title": "Functions",
    "category": "section",
    "text": ""
},

{
    "location": "#ImageBinarization.binarize-Tuple{AdaptiveThreshold,AbstractArray{#s5,2} where #s5<:Colorant}",
    "page": "ImageBinarization.jl Documentation",
    "title": "ImageBinarization.binarize",
    "category": "method",
    "text": "binarize(AdaptiveThreshold(; percentage = 15, window_size = 32), img)\n\nUses a binarization threshold that varies across the image according to background illumination.\n\nOutput\n\nReturns the binarized image as an Array{Gray{Bool},2}.\n\nDetails\n\nIf the value of a pixel is t percent less than the  average of an s times s window of pixels centered around the pixel, then the pixel is set to black, otherwise it is set to white.\n\nA computationally efficient method for computing the average of an s times s neighbourhood is achieved by using an integral image.\n\nThis algorithm works particularly well on images that have distinct contrast between background and foreground. See [1] for more details.\n\nOptions\n\nVarious options for the parameters of this function are described in more detail below.\n\nChoices for percentage\n\nYou can specify an integer for the percentage (denoted by t in the publication) which must be between 0 and 100. If left unspecified a default value of 15 is utilised.\n\nChoices for window_size\n\nThe argument window_size (denoted by s in the publication)  specifies the size of pixel\'s square neighbourhood which must be greater than zero. A recommended size is the integer value which is closest to 1/8 of the average of the width and height. You can use the convenience function recommend_size(::AbstractArray{T,2}) to obtain this suggested value. If left unspecified, a default value of 32 is utilised.\n\n#Example\n\nusing TestImages\n\nimg = testimage(\"cameraman\")\ns = recommend_size(img)\nbinarize(AdaptiveThreshold(percentage = 15, window_size = s), img)\n\nReferences\n\nBradley, D. (2007). Adaptive Thresholding using Integral Image. Journal of Graphic Tools, 12(2), pp.13-21. doi:10.1080/2151237x.2007.10129236\n\n\n\n\n\n"
},

{
    "location": "#Adaptive-Threshold-1",
    "page": "ImageBinarization.jl Documentation",
    "title": "Adaptive Threshold",
    "category": "section",
    "text": "binarize(::AdaptiveThreshold, ::AbstractArray{<: Colorant,2})"
},

{
    "location": "#ImageBinarization.binarize-Tuple{Balanced,AbstractArray{#s5,2} where #s5<:Colorant}",
    "page": "ImageBinarization.jl Documentation",
    "title": "ImageBinarization.binarize",
    "category": "method",
    "text": "binarize(Balanced(), img)\n\nBinarizes the image using the balanced histogram thresholding method.\n\nOutput\n\nReturns the binarized image as an Array{Gray{Bool},2}.\n\nDetails\n\nIn balanced histogram thresholding, one interprets a  bin as a  physical weight with a mass equal to its occupancy count. The balanced histogram method involves iterating the following three steps: (1) choose the midpoint bin index as a \"pivot\",  (2) compute the combined weight to the left and right of the pivot bin and (3) remove the leftmost bin if the left side is the heaviest, and the rightmost bin otherwise. The algorithm stops when only a single bin remains. The last bin determines the sought-after threshold with which the image is binarized.\n\nLet f_n (n = 1 ldots N) denote the number of observations in the nth bin of the image histogram. The balanced histogram method constructs a sequence of nested intervals\n\n1N cap mathbbZ supset I_2 supset I_3 supset ldots supset I_N-1\n\nwhere for k = 2 ldots N-1\n\nI_k = begincases\n   I_k-1 setminus min left( I_k-1 right)  textif  sum_n = min left( I_k-1 right)^I_mf_n gt   sum_n =  I_m + 1^ max left( I_k-1 right) f_n \r\n   I_k-1 setminus max left( I_k-1 right)  textotherwise\nendcases\n\nand I_m = lfloor frac12left(  min left( I_k-1 right) +  max left( I_k-1 right) right) rfloor. The final interval I_N-1 consists of a single element which is the bin index corresponding to the desired threshold.\n\nIf one interprets a bin as a physical weight with a mass equal to its occupancy count, then each step of the algorithm can be conceptualised as removing the leftmost or rightmost bin to \"balance\" the resulting histogram on a pivot. The pivot is defined to be the midpoint between the start and end points of the interval under consideration.\n\nIf it turns out that the single element in I_N-1 equals 1 or N then the original histogram must have a single peak and the algorithm has failed to find a suitable threshold. In this case the algorithm will fall back to using the UnimodalRosin method to select the threshold.\n\nArguments\n\nThe function argument is described in more detail below.\n\nimg\n\nAn AbstractArray representing an image. The image is automatically converted to Gray in order to construct the requisite graylevel histogram.\n\nExample\n\nBinarize the \"cameraman\" image in the TestImages package.\n\nusing TestImages, ImageBinarization\n\nimg = testimage(\"cameraman\")\nimg_binary = binarize(Balanced(), img)\n\nReference\n\n“BI-LEVEL IMAGE THRESHOLDING - A Fast Method”, Proceedings of the First International Conference on Bio-inspired Systems and Signal Processing, 2008. Available: 10.5220/0001064300700076\n\n\n\n\n\n"
},

{
    "location": "#Balanced-1",
    "page": "ImageBinarization.jl Documentation",
    "title": "Balanced",
    "category": "section",
    "text": "binarize(::Balanced,  ::AbstractArray{<: Colorant,2})"
},

{
    "location": "#ImageBinarization.binarize-Union{Tuple{T}, Tuple{Entropy,AbstractArray{T,2}}} where T<:Colorant",
    "page": "ImageBinarization.jl Documentation",
    "title": "ImageBinarization.binarize",
    "category": "method",
    "text": "binarize(Entropy(), img)\n\nAn algorithm for finding the binarization threshold value using the entropy of the image histogram.\n\nOutput\n\nReturns the binarized image as an Array{Gray{Bool},2}.\n\nDetails\n\nThis algorithm uses the entropy of a one-dimensional histogram to produce a threshold value.\n\nLet f_1 f_2 ldots f_I be the frequencies in the various bins of the histogram and I the number of bins. With N = sum_i=1^If_i, let p_i = fracf_iN (i = 1 ldots I) denote the probability distribution of gray levels. From this distribution one derives two additional distributions. The first defined for discrete values 1 to s and the other, from s+1 to I. These distributions are\n\nA fracp_1P_s fracp_2P_s ldots fracp_sP_s\nquad textand quad\nB fracp_s+11-P_s ldots fracp_n1-P_s\nquad textwhere quad\nP_s = sum_i=1^sp_i\n\nThe entropies associated with each distribution are as follows:\n\nH(A) = ln(P_s) + fracH_sP_s\n\nH(B) = ln(1-P_s) + fracH_n-H_s1-P_s\n\nquad textwhere quad\nH_s = -sum_i=1^sp_ilnp_i\nquad textand quad\nH_n = -sum_i=1^Ip_ilnp_i\n\nCombining these two entropy functions we have\n\npsi(s) = ln(P_s(1-P_s)) + fracH_sP_s + fracH_n-H_s1-P_s\n\nFinding the discrete value s which maximises the function psi(s) produces the sought-after threshold value (i.e. the bin which determines the threshold).\n\nSee Section 4 of [1] for more details on the derivation of the entropy.\n\nArguments\n\nThe function argument is described in more detail below.\n\nimg\n\nAn AbstractArray representing an image. The image is automatically converted to Gray in order to construct the requisite graylevel histogram.\n\nExample\n\nBinarize the \"cameraman\" image in the TestImages package.\n\nusing TestImages, ImageBinarization\n\nimg = testimage(\"cameraman\")\nimg_binary = binarize(Entropy(), img)\n\nReferences\n\nJ. N. Kapur, P. K. Sahoo, and A. K. C. Wong, “A new method for gray-level picture thresholding using the entropy of the histogram,” Computer Vision, Graphics, and Image Processing, vol. 29, no. 1, p. 140, Jan. 1985.doi:10.1016/s0734-189x(85)90156-2\n\n\n\n\n\n"
},

{
    "location": "#Entropy-1",
    "page": "ImageBinarization.jl Documentation",
    "title": "Entropy",
    "category": "section",
    "text": "binarize(::Entropy,  ::AbstractArray{T,2}) where T <: Colorant"
},

{
    "location": "#ImageBinarization.binarize-Tuple{Intermodes,AbstractArray{#s5,2} where #s5<:Colorant}",
    "page": "ImageBinarization.jl Documentation",
    "title": "ImageBinarization.binarize",
    "category": "method",
    "text": "binarize(Intermodes(), img)\n\nUnder the assumption that the image histogram is bimodal the image histogram is smoothed using a length-3 mean filter until two modes remain. The binarization threshold is then set to the average value of the two modes.\n\nOutput\n\nReturns the binarized image as an Array{Gray{Bool},2}.\n\nArguments\n\nThe function argument is described in more detail below.\n\nimg\n\nAn AbstractArray representing an image. The image is automatically converted to Gray in order to construct the requisite graylevel histogram.\n\nExample\n\nBinarize the \"cameraman\" image in the TestImages package.\n\nusing TestImages, ImageBinarization\n\nimg = testimage(\"cameraman\")\nimg_binary = binarize(Intermodes(), img)\n\nReference\n\nC. A. Glasbey, “An Analysis of Histogram-Based Thresholding Algorithms,” CVGIP: Graphical Models and Image Processing, vol. 55, no. 6, pp. 532–537, Nov. 1993. doi:10.1006/cgip.1993.1040\n\n\n\n\n\n"
},

{
    "location": "#Intermodes-1",
    "page": "ImageBinarization.jl Documentation",
    "title": "Intermodes",
    "category": "section",
    "text": "binarize(::Intermodes,  ::AbstractArray{<: Colorant,2})"
},

{
    "location": "#ImageBinarization.binarize-Tuple{MinimumError,AbstractArray{#s5,2} where #s5<:Colorant}",
    "page": "ImageBinarization.jl Documentation",
    "title": "ImageBinarization.binarize",
    "category": "method",
    "text": "binarize(MinimumError(), img)\n\nUnder the assumption that the image histogram is a mixture of two Gaussian distributions the binarization threshold is chosen such that the expected misclassification error rate is minimised.\n\nOutput\n\nReturns the binarized image as an Array{Gray{Bool},2}.\n\nDetails\n\nLet f_i (i=1 ldots I) denote the number of observations in the ith bin of the histogram. Then the probability that an observation belongs to the ith bin is given by  p_i = fracf_iN (i = 1 ldots I), where N = sum_i=1^If_i.\n\nThe minimum error thresholding method assumes that one can find a threshold T which partitions the data into two categories,  C_0 and C_1, such that the data can be modelled by a mixture of two Gaussian distribution. Let\n\nP_0(T) = sum_i = 1^T p_i quad textand quad P_1(T) = sum_i = T+1^I p_i\n\ndenote the cumulative probabilities,\n\nmu_0(T) = sum_i = 1^T i fracp_iP_0(T) quad textand quad mu_1(T) = sum_i = T+1^I i fracp_iP_1(T)\n\ndenote the means, and\n\nsigma_0^2(T) = sum_i = 1^T (i-mu_0(T))^2 fracp_iP_0(T) quad textand quad sigma_1^2(T) = sum_i = T+1^I (i-mu_1(T))^2 fracp_iP_1(T)\n\ndenote the variances of categories C_0 and C_1, respectively.\n\nKittler and Illingworth proposed to use the minimum error criterion function\n\nJ(T) = 1 + 2 left P_0(T) ln sigma_0(T) + P_1(T) ln sigma_1(T) right - 2 leftP_0(T) ln P_0(T) + P_1(T) ln P_1(T) right\n\nto assess the discreprancy between the mixture of Gaussians implied by a particular threshold T, and the piecewise-constant probability density function represented by the histogram. The discrete value T which minimizes the function J(T) produces the sought-after threshold value (i.e. the bin which determines the threshold).\n\nArguments\n\nThe function argument is described in more detail below.\n\nimg\n\nAn AbstractArray representing an image. The image is automatically converted to Gray in order to construct the requisite graylevel histogram.\n\nExample\n\nBinarize the \"cameraman\" image in the TestImages package.\n\nusing TestImages, ImageBinarization\n\nimg = testimage(\"cameraman\")\nimg_binary = binarize(MinimumError(), img)\n\nReferences\n\nJ. Kittler and J. Illingworth, “Minimum error thresholding,” Pattern Recognition, vol. 19, no. 1, pp. 41–47, Jan. 1986. doi:10.1016/0031-3203(86)90030-0\nQ.-Z. Ye and P.-E. Danielsson, “On minimum error thresholding and its implementations,” Pattern Recognition Letters, vol. 7, no. 4, pp. 201–206, Apr. 1988. doi:10.1016/0167-8655(88)90103-1\n\n\n\n\n\n"
},

{
    "location": "#Minimum-Error-1",
    "page": "ImageBinarization.jl Documentation",
    "title": "Minimum Error",
    "category": "section",
    "text": "binarize(::MinimumError,  ::AbstractArray{<: Colorant,2})"
},

{
    "location": "#ImageBinarization.binarize-Tuple{MinimumIntermodes,AbstractArray{#s5,2} where #s5<:Colorant}",
    "page": "ImageBinarization.jl Documentation",
    "title": "ImageBinarization.binarize",
    "category": "method",
    "text": "binarize(MinimumIntermodes(), img)\n\nUnder the assumption that the image histogram is bimodal the histogram is smoothed using a length-3 mean filter until two modes remain. The binarization threshold is then set to the minimum value between the two modes.\n\nOutput\n\nReturns the binarized image as an Array{Gray{Bool},2}.\n\nArguments\n\nThe function argument is described in more detail below.\n\nimg\n\nAn AbstractArray representing an image. The image is automatically converted to Gray in order to construct the requisite graylevel histogram.\n\nExample\n\nBinarize the \"cameraman\" image in the TestImages package.\n\nusing TestImages, ImageBinarization\n\nimg = testimage(\"cameraman\")\nimg_binary = binarize(MinimumIntermodes(), img)\n\nReference\n\nC. A. Glasbey, “An Analysis of Histogram-Based Thresholding Algorithms,” CVGIP: Graphical Models and Image Processing, vol. 55, no. 6, pp. 532–537, Nov. 1993. doi:10.1006/cgip.1993.1040\nJ. M. S. Prewitt and M. L. Mendelsohn, “THE ANALYSIS OF CELL IMAGES,” *Annals of the New York Academy of Sciences, vol. 128, no. 3, pp. 1035–1053, Dec. 2006. doi:10.1111/j.1749-6632.1965.tb11715.x\n\n\n\n\n\n"
},

{
    "location": "#Minimum-Intermodes-1",
    "page": "ImageBinarization.jl Documentation",
    "title": "Minimum Intermodes",
    "category": "section",
    "text": "binarize(::MinimumIntermodes,  ::AbstractArray{<: Colorant,2})"
},

{
    "location": "#ImageBinarization.binarize-Tuple{Moments,AbstractArray{#s5,2} where #s5<:Colorant}",
    "page": "ImageBinarization.jl Documentation",
    "title": "ImageBinarization.binarize",
    "category": "method",
    "text": "binarize(Moments(), img)\n\nThe following rule determines the binarization threshold:  if one assigns all observations below the threshold to a value z₀ and all observations above the threshold to a value z₁, then the first three moments of the original histogram must match the moments of this specially constructed bilevel histogram.\n\nOutput\n\nReturns the binarized image as an Array{Gray{Bool},2}.\n\nDetails\n\nLet f_i (i=1 ldots I) denote the number of observations in the ith bin of the histogram and z_i (i=1 ldots I) the observed value associated with the ith bin.  Then the probability that an observation z_i belongs to the ith bin is given by  p_i = fracf_iN (i = 1 ldots I), where N = sum_i=1^If_i.\n\nMoments can be computed from the histogram f in the following way:\n\nm_k = frac1N sum_i p_i (z_i)^k quad k = 0123 ldots\n\nThe principle of moment-preserving thresholding is to select a threshold value, as well as two representative values z_0 and z_1 (z_0  z_1), such that if all below-threshold values in f are replaced by z_0 and all above-threshold values are replaced by z_1, then this specially constructed bilevel histogram g will have the same first three moments as f.\n\nConcretely, let q_0 and q_1 denote the fractions of observations below and above the threshold in f, respectively. The constraint that the first three moments in g must equal the first three moments in f can be expressed by the following system of four equations\n\nbeginaligned\n   q_0 (z_0)^0 + q_1 (z_1)^0    = m_0 \n   q_0 (z_0)^1 + q_1 (z_1)^1    = m_1 \n   q_0 (z_0)^2 + q_1 (z_1)^2    = m_2 \n   q_0 (z_0)^3 + q_1 (z_1)^3    = m_3 \nendaligned\n\nwhere the left-hand side represents the moments of g and the right-hand side represents the moments of f. To find the desired treshold value, one first solves the four equations to obtain q_0 and q_1, and then chooses the threshold t such that q_0 = sum_z_i le t p_i.\n\nArguments\n\nThe function argument is described in more detail below.\n\nimg\n\nAn AbstractArray representing an image. The image is automatically converted to Gray in order to construct the requisite graylevel histogram.\n\nExample\n\nBinarize the \"cameraman\" image in the TestImages package.\n\nusing TestImages, ImageBinarization\n\nimg = testimage(\"cameraman\")\nimg_binary = binarize(Moments(), img)\n\nReference\n\n[1] W.-H. Tsai, “Moment-preserving thresolding: A new approach,” Computer Vision, Graphics, and Image Processing, vol. 29, no. 3, pp. 377–393, Mar. 1985. doi:10.1016/0734-189x(85)90133-1\n\n\n\n\n\n"
},

{
    "location": "#Moments-1",
    "page": "ImageBinarization.jl Documentation",
    "title": "Moments",
    "category": "section",
    "text": "binarize(::Moments,  ::AbstractArray{<: Colorant,2})"
},

{
    "location": "#ImageBinarization.binarize-Tuple{Niblack,AbstractArray{#s5,2} where #s5<:Colorant}",
    "page": "ImageBinarization.jl Documentation",
    "title": "ImageBinarization.binarize",
    "category": "method",
    "text": "binarize(Niblack(; window_size = 7, bias = 0.2), img)\n\nApplies Niblack adaptive thresholding [1] under the assumption that the input image is textual.\n\nOutput\n\nReturns the binarized image as an Array{Gray{Bool},2}.\n\nDetails\n\nThe input image is binarized by varying the threshold across the image, using a modified version of Niblack\'s algorithm [2]. A threshold T is defined for each pixel based on the mean m and standard deviation s of the intensities of neighboring pixels in a window around it. This threshold is given by\n\nT(xy) = m(xy) + k cdot s(xy)\n\nwhere k is a user-defined parameter weighting the influence of the standard deviation on the value of T.\n\nNote that Niblack\'s algorithm is highly sensitive to variations in the gray values of background pixels, which often exceed local thresholds and appear as artifacts in the binarized image. The Sauvola algorithm included in this package implements an attempt to address this issue [2].\n\nArguments\n\nimg\n\nAn image which is binarized according to a per-pixel adaptive threshold into background (0) and foreground (1) pixel values.\n\nwindow_size (denoted by w in the publication)\n\nThe threshold for each pixel is a function of the distribution of the intensities of all neighboring pixels in a square window around it. The side length of this window is 2w + 1, with the target pixel in the center position.\n\nbias  (denoted by k in the publication)\n\nA user-defined biasing parameter. This can take negative values.\n\nExample\n\nBinarize the \"cameraman\" image in the TestImages package.\n\nusing TestImages, ImageBinarization\n\nimg = testimage(\"cameraman\")\nimg_binary = binarize(Niblack(window_size = 9, bias = 0.2), img)\n\nReferences\n\nWayne Niblack (1986). An Introduction to Image Processing. Prentice-Hall, Englewood Cliffs, NJ: 115-16.\nJ. Sauvola and M. Pietikäinen (2000). \"Adaptive document image binarization\". Pattern Recognition 33 (2): 225-236. doi:10.1016/S0031-3203(99)00055-2\n\n\n\n\n\n"
},

{
    "location": "#Niblack-1",
    "page": "ImageBinarization.jl Documentation",
    "title": "Niblack",
    "category": "section",
    "text": "binarize(::Niblack,  ::AbstractArray{<: Colorant,2})"
},

{
    "location": "#ImageBinarization.binarize-Tuple{Otsu,AbstractArray{#s5,2} where #s5<:Colorant}",
    "page": "ImageBinarization.jl Documentation",
    "title": "ImageBinarization.binarize",
    "category": "method",
    "text": "binarize(Otsu(), img)\n\nUnder the assumption that the image histogram is bimodal the binarization threshold is set so that the resultant between-class variance is maximal.\n\nOutput\n\nReturns the binarized image as an Array{Gray{Bool},2}.\n\nDetails\n\nLet f_i (i=1 ldots I) denote the number of observations in the ith bin of the image histogram. Then the probability that an observation belongs to the ith bin is given by  p_i = fracf_iN (i = 1 ldots I), where N = sum_i=1^If_i.\n\nThe choice of a threshold T partitions the data into two categories, C_0 and C_1. Let\n\nP_0(T) = sum_i = 1^T p_i quad textand quad P_1(T) = sum_i = T+1^I p_i\n\ndenote the cumulative probabilities,\n\nmu_0(T) = sum_i = 1^T i fracp_iP_0(T) quad textand quad mu_1(T) = sum_i = T+1^I i fracp_iP_1(T)\n\ndenote the means, and\n\nsigma_0^2(T) = sum_i = 1^T (i-mu_0(T))^2 fracp_iP_0(T) quad textand quad sigma_1^2(T) = sum_i = T+1^I (i-mu_1(T))^2 fracp_iP_1(T)\n\ndenote the variances of categories C_0 and C_1, respectively. Furthermore, let\n\nmu = P_0(T)mu_0(T) + P_1(T)mu_1(T)\n\nrepresent the overall mean,\n\nsigma_b^2(T) = P_0(T)(mu_0(T) - mu)^2 + P_1(T)(mu_1(T) - mu)^2\n\nthe between-category variance, and\n\nsigma_w^2(T) = P_0(T) sigma_0^2(T) +  P_1(T)sigma_1^2(T)\n\nthe within-category variance, respectively.\n\nFinding the discrete value T which maximises the function sigma_b^2(T) produces the sought-after threshold value (i.e. the bin which determines the threshold). As it turns out, that threshold value is equal to the threshold decided by minimizing the within-category variances criterion sigma_w^2(T). Furthermore, that threshold is also the same as the threshold calculated by maximizing the ratio of between-category variance to within-category variance.\n\nArguments\n\nThe function argument is described in more detail below.\n\nimg\n\nAn AbstractArray representing an image. The image is automatically converted to Gray in order to construct the requisite graylevel histogram.\n\nExample\n\nBinarize the \"cameraman\" image in the TestImages package.\n\nusing TestImages, ImageBinarization\n\nimg = testimage(\"cameraman\")\nimg_binary = binarize(Otsu(), img)\n\nReference\n\nNobuyuki Otsu (1979). “A threshold selection method from gray-level histograms”. IEEE Trans. Sys., Man., Cyber. 9 (1): 62–66. doi:10.1109/TSMC.1979.4310076\n\n\n\n\n\n"
},

{
    "location": "#Otsu-1",
    "page": "ImageBinarization.jl Documentation",
    "title": "Otsu",
    "category": "section",
    "text": "binarize(::Otsu,  ::AbstractArray{<: Colorant,2})"
},

{
    "location": "#ImageBinarization.binarize-Tuple{Polysegment,AbstractArray{#s5,2} where #s5<:Colorant}",
    "page": "ImageBinarization.jl Documentation",
    "title": "ImageBinarization.binarize",
    "category": "method",
    "text": "binarize(Polysegment(), img)\n\nUses the polynomial segmentation technique to group the image pixels into two categories (foreground and background).\n\nDetails\n\nThe approach involves constructing a univariate second-degree polynomial such that the two roots of the polynomial represent the graylevels of two cluster centers (i.e the foreground and background). Pixels are then assigned to the foreground or background depending on which cluster center is closest.\n\nArguments\n\nThe function argument is described in more detail below.\n\nimg\n\nAn AbstractArray representing an image. The image is automatically converted to Gray.\n\nExample\n\nBinarize the \"cameraman\" image in the TestImages package.\n\nusing TestImages, ImageBinarization\n\nimg = testimage(\"cameraman\")\nimg_binary = binarize(Polysegment(), img)\n\nReference\n\nR. E. Vidal, \"Generalized Principal Component Analysis (GPCA): An Algebraic Geometric Approach to Subspace Clustering and Motion Segmentation.\" Order No. 3121739, University of California, Berkeley, Ann Arbor, 2003.\n\n\n\n\n\n"
},

{
    "location": "#Polysegment-1",
    "page": "ImageBinarization.jl Documentation",
    "title": "Polysegment",
    "category": "section",
    "text": "binarize(::Polysegment,  ::AbstractArray{<: Colorant,2})"
},

{
    "location": "#ImageBinarization.binarize-Tuple{Sauvola,AbstractArray{#s5,2} where #s5<:Colorant}",
    "page": "ImageBinarization.jl Documentation",
    "title": "ImageBinarization.binarize",
    "category": "method",
    "text": "binarize(Sauvola(; window_size = 7, bias = 0.2), img)\n\nApplies Sauvola–Pietikäinen adaptive image binarization [1] under the assumption that the input image is textual.\n\nOutput\n\nReturns the binarized image as an Array{Gray{Bool},2}.\n\nDetails\n\nThe input image is binarized by varying the threshold across the image, using a modified version of Niblack\'s algorithm [2]. Niblack\'s approach was to define a threshold T for each pixel based on the mean m and standard deviation s of the intensities of neighboring pixels in a window around it, given by\n\nT(xy) = m(xy) + k cdot s(xy)\n\nwhere k is a user-defined parameter weighting the influence of the standard deviation on the value of T.\n\nNiblack\'s algorithm is highly sensitive to variations in the gray values of background pixels, which often exceed local thresholds and appear as artifacts in the binarized image. Sauvola and Pietikäinen [1] introduce the dynamic range R of the standard deviation (i.e. its maximum possible value in the color space), such that the threshold is given by\n\nT(xy) = m(xy) cdot left 1 + k cdot left( fracs(xy)R - 1 right) right\n\nThis adaptively amplifies the contribution made by the standard deviation to the value of T.\n\nThe Sauvola–Pietikäinen algorithm is implemented here using an optimization proposed by Shafait, Keysers and Breuel [3], in which integral images are used to calculate the values of m and s for each pixel in constant time. Since each of these data structures can be computed in a single pass over the source image, runtime is significantly improved.\n\nArguments\n\nimg\n\nAn image which is binarized according to a per-pixel adaptive threshold into background (0) and foreground (1) pixel values.\n\nwindow_size (denoted by w in the publication)\n\nThe threshold for each pixel is a function of the distribution of the intensities of all neighboring pixels in a square window around it. The side length of this window is 2w + 1, with the target pixel in the center position.\n\nbias (denoted by k in the publication)\n\nA user-defined biasing parameter. This can take negative values, though values in the range [0.2, 0.5] are typical.\n\nExample\n\nBinarize the \"cameraman\" image in the TestImages package.\n\nusing TestImages, ImageBinarization\n\nimg = testimage(\"cameraman\")\nimg_binary = binarize(Sauvola(window_size = 9, bias = 0.2), img)\n\nReferences\n\nJ. Sauvola and M. Pietikäinen (2000). \"Adaptive document image binarization\". Pattern Recognition 33 (2): 225-236. doi:10.1016/S0031-3203(99)00055-2\nWayne Niblack (1986). An Introduction to Image Processing. Prentice-Hall, Englewood Cliffs, NJ: 115-16.\nFaisal Shafait, Daniel Keysers and Thomas M. Breuel (2008). \"Efficient implementation of local adaptive thresholding techniques using integral images\". Proc. SPIE 6815, Document Recognition and Retrieval XV, 681510 (28 January 2008). doi:10.1117/12.767755\n\n\n\n\n\n"
},

{
    "location": "#Sauvola-1",
    "page": "ImageBinarization.jl Documentation",
    "title": "Sauvola",
    "category": "section",
    "text": "binarize(::Sauvola,  ::AbstractArray{<: Colorant,2})"
},

{
    "location": "#ImageBinarization.binarize-Tuple{UnimodalRosin,AbstractArray{#s5,2} where #s5<:Colorant}",
    "page": "ImageBinarization.jl Documentation",
    "title": "ImageBinarization.binarize",
    "category": "method",
    "text": "binarize(UnimodalRosin(), img)\n\nUses Rosin\'s Unimodal threshold algorithm to binarize the image.\n\nOutput\n\nReturns the binarized image as an Array{Gray{Bool},2}.\n\nDetails\n\nThis algorithm first selects the bin in the image histogram with the highest frequency. The algorithm then searches from the location of the maximum bin to the last bin of the histogram for the first bin with a frequency of 0 (known as the minimum bin.). A line is then drawn that passes through both the maximum and minimum bins. The bin with the greatest orthogonal distance to the line is chosen as the threshold value.\n\nAssumptions\n\nThis algorithm assumes that:\n\nThe histogram is unimodal.\nThere is always at least one bin that has a frequency of 0. If not, the algorithm will use the last bin as the minimum bin.\n\nIf the histogram includes multiple bins with a frequency of 0, the algorithm will select the first zero bin as its minimum. If there are multiple bins with the greatest orthogonal distance, the leftmost bin is selected as the threshold.\n\nArguments\n\nThe function argument is described in more detail below.\n\nimg\n\nAn AbstractArray representing an image. The image is automatically converted to Gray in order to construct the requisite graylevel histogram.\n\nExample\n\nCompute the threshold for the \"moonsurface\" image in the TestImages package.\n\nusing TestImages, ImageBinarization\n\nimg = testimage(\"moonsurface\")\nimg_binary = binarize(UnimodalRosin(), img)\n\nReference\n\nP. L. Rosin, “Unimodal thresholding,” Pattern Recognition, vol. 34, no. 11, pp. 2083–2096, Nov. 2001.doi:10.1016/s0031-3203(00)00136-9\n\n\n\n\n\n"
},

{
    "location": "#Unimodal-Rosin-1",
    "page": "ImageBinarization.jl Documentation",
    "title": "Unimodal Rosin",
    "category": "section",
    "text": "binarize(::UnimodalRosin,  ::AbstractArray{<: Colorant,2})"
},

{
    "location": "#ImageBinarization.binarize-Tuple{Yen,AbstractArray{#s5,2} where #s5<:Colorant}",
    "page": "ImageBinarization.jl Documentation",
    "title": "ImageBinarization.binarize",
    "category": "method",
    "text": "binarize(Yen(), img)\n\nComputes the binarization threshold value using Yen\'s maximum correlation criterion for bilevel thresholding.\n\nOutput\n\nReturns the binarized image as an Array{Gray{Bool},2}.\n\nDetails\n\nThis algorithm uses the concept of entropic correlation of a gray level histogram to produce a threshold value.\n\nLet f_1 f_2 ldots f_I be the frequencies in the various bins of the histogram and I the number of bins. With N = sum_i=1^If_i, let p_i = fracf_iN (i = 1 ldots I) denote the probability distribution of gray levels. From this distribution one derives two additional distributions. The first defined for discrete values 1 to s and the other, from s+1 to I. These distributions are\n\nA fracp_1P_s fracp_2P_s ldots fracp_sP_s\nquad textand quad\nB fracp_s+11-P_s ldots fracp_n1-P_s\nquad textwhere quad\nP_s = sum_i=1^sp_i\n\nThe entropic correlations associated with each distribution are\n\nC(A) = -ln sum_i=1^s left( fracp_iP_s right)^2 quad textand quad C(B) = -ln sum_i=s+1^I left( fracp_i1 - P_s right)^2\n\nCombining these two entropic correlation functions we have\n\npsi(s) = -ln sum_i=1^s left( fracp_iP_s right)^2 -ln sum_i=s+1^I left( fracp_i1 - P_s right)^2\n\nFinding the discrete value s which maximises the function psi(s) produces the sought-after threshold value (i.e. the bin which determines the threshold).\n\nArguments\n\nThe function argument is described in more detail below.\n\nimg\n\nAn AbstractArray representing an image. The image is automatically converted to Gray in order to construct the requisite graylevel histogram.\n\nExample\n\nBinarize the \"cameraman\" image in the TestImages package.\n\nusing TestImages, ImageBinarization\n\nimg = testimage(\"cameraman\")\nimg_binary = binarize(Yen(), img)\n\nReference\n\nYen JC, Chang FJ, Chang S (1995), “A New Criterion for Automatic Multilevel Thresholding”, IEEE Trans. on Image Processing 4 (3): 370-378, doi:10.1109/83.366472\n\n\n\n\n\n"
},

{
    "location": "#Yen-1",
    "page": "ImageBinarization.jl Documentation",
    "title": "Yen",
    "category": "section",
    "text": "binarize(::Yen,  ::AbstractArray{<: Colorant,2})"
},

]}
