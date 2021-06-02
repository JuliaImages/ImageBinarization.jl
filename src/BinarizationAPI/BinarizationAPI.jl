# This is a temporary module to validate `AbstractImageFilter` idea
# proposed in https://github.com/JuliaImages/ImagesAPI.jl/pull/3
module BinarizationAPI

using ImageCore # we actually only need ColorTypes
const GenericGrayImage = AbstractArray{<:Union{Number, AbstractGray}}

"""
    AbstractImageAlgorithm

The root of image algorithms type system
"""
abstract type AbstractImageAlgorithm end

"""
    AbstractImageFilter <: AbstractImageAlgorithm

Filters are image algorithms whose input and output are both images
"""
abstract type AbstractImageFilter <: AbstractImageAlgorithm end

include("binarize.jl")

# we do not export any symbols since we don't require
# package developers to implemente all the APIs

end  # module BinarizationAPI
