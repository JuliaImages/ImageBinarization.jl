push!(LOAD_PATH,"../src/")
using Documenter, ImageBinarization, ColorTypes, ColorVectorSpace
makedocs(sitename="Documentation",
            Documenter.HTML(prettyurls = get(ENV, "CI", nothing) == "true"))
deploydocs(repo = "github.com/zygmuntszpak/ImageBinarization.jl.git")
