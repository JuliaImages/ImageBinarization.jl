function get_window_bounds(img::AbstractArray{T,2}, pixel::CartesianIndex{2},
                           w::Integer) where T <: Color
    row, col = pixel.I
    min_row, min_col = first.(axes(img))
    max_row, max_col = last.(axes(img))

    row₀ = max(row - w, min_row)
    col₀ = max(col - w, min_col)
    row₁ = min(row + w, max_row)
    col₁ = min(col + w, max_col)

    return row₀, col₀, row₁, col₁
end

function μ_in_window(I::AbstractArray{T,2}, row₀::Integer, col₀::Integer,
                     row₁::Integer, col₁::Integer) where T <: Real
    μ = boxdiff(I, row₀:row₁, col₀:col₁) / ((row₁-row₀+1)*(col₁-col₀+1))
    return μ < eps() ? zero(eltype(I)) : μ
end

function σ²_in_window(I²::AbstractArray{T,2}, μ::Real, row₀::Integer,
                      col₀::Integer, row₁::Integer, col₁::Integer) where T <: Real
    σ² = μ_in_window(I², row₀, col₀, row₁, col₁) - μ^2
    return σ² < eps() ? zero(eltype(I²)) : σ²
end

function σ_in_window(I²::AbstractArray{T,2}, μ::Real, row₀::Integer,
                     col₀::Integer, row₁::Integer, col₁::Integer) where T <: Real
    σ² = σ²_in_window(I², μ, row₀, col₀, row₁, col₁)
    return σ² < eps() ? zero(eltype(I²)) : sqrt(σ²)
end
