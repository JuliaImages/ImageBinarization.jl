var documenterSearchIndex = {"docs": [

{
    "location": "#",
    "page": "ImageBinarization.jl Documentation",
    "title": "ImageBinarization.jl Documentation",
    "category": "page",
    "text": ""
},

{
    "location": "#ImageBinarization.binarize-Tuple{Otsu,AbstractArray{#s1,2} where #s1<:(Color{T,1} where T)}",
    "page": "ImageBinarization.jl Documentation",
    "title": "ImageBinarization.binarize",
    "category": "method",
    "text": "imgb = binarize(Otsu(), img)\nbinarize!(Otsu(), img)\n\nUnder the assumption that the histogram is bimodal the threshold is set so that the resultant inter-class variance is maximal.\n\nArguments\n\nThe function arguments are described in more detail below.\n\nimg\n\nAn AbstractGray image which is to be binarized into background (Gray(0)) and foreground (Gray(1)) pixels.\n\nReference\n\nNobuyuki Otsu (1979). \"A threshold selection method from gray-level histograms\". IEEE Trans. Sys., Man., Cyber. 9 (1): 62–66. doi:10.1109/TSMC.1979.4310076\n\n\n\n\n\n"
},

{
    "location": "#ImageBinarization.binarize-Tuple{Polysegment,AbstractArray{#s1,2} where #s1<:(Color{T,1} where T)}",
    "page": "ImageBinarization.jl Documentation",
    "title": "ImageBinarization.binarize",
    "category": "method",
    "text": "imgb = binarize(Polysegment(), img)\nbinarize!(Polysegment(), img)\n\nUses the polynomial segmentation technique to group the image pixels into two categories (foreground and background).\n\nDetails\n\nThe approach involves constructing a univariate second-degree polynomial such that the two roots of the polynomial represent the graylevels of two cluster centers (i.e the foreground and background). Pixels are then assigned to the foreground or background depending on which cluster center is closest.\n\nArguments\n\nThe function arguments are described in more detail below.\n\nimg\n\nAn AbstractGray image which is to be binarized into background (Gray(0)) and foreground (Gray(1)) pixels.\n\nReference\n\n[1] R. E. Vidal, \"Generalized Principal Component Analysis (GPCA): An Algebraic Geometric Approach to Subspace Clustering and Motion Segmentation.\" Order No. 3121739, University of California, Berkeley, Ann Arbor, 2003.\n\n\n\n\n\n"
},

{
    "location": "#ImageBinarization.binarize!-Tuple{Otsu,AbstractArray{#s1,2} where #s1<:(Color{T,1} where T)}",
    "page": "ImageBinarization.jl Documentation",
    "title": "ImageBinarization.binarize!",
    "category": "method",
    "text": "t = binarize!(Otsu(), img)\n\nSame as binarize except that it modifies the image that was passed as an argument.\n\n\n\n\n\n"
},

{
    "location": "#ImageBinarization.binarize!-Tuple{Polysegment,AbstractArray{#s1,2} where #s1<:(Color{T,1} where T)}",
    "page": "ImageBinarization.jl Documentation",
    "title": "ImageBinarization.binarize!",
    "category": "method",
    "text": "t = binarize!(Polysegment(), img)\n\nSame as binarize except that it modifies the image that was passed as an argument.\n\n\n\n\n\n"
},

{
    "location": "#ImageBinarization.jl-Documentation-1",
    "page": "ImageBinarization.jl Documentation",
    "title": "ImageBinarization.jl Documentation",
    "category": "section",
    "text": "binarize(::Otsu, ::AbstractArray{<:AbstractGray,2})\nbinarize(::Polysegment, ::AbstractArray{<:AbstractGray,2})\nbinarize!(::Otsu, ::AbstractArray{<:AbstractGray,2})\nbinarize!(::Polysegment, ::AbstractArray{<:AbstractGray,2})"
},

]}
