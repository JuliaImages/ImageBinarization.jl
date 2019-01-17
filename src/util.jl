function get_window_bounds(img::AbstractArray{T,2}, pixel::CartesianIndex, w::Integer) where T <: Color
    row, col = pixel.I
    row_min, col_min = first.(axes(img))
    row_max, col_max = last.(axes(img))

    row₀ = max(row - w, row_min)
    col₀ = max(col - w, col_min)
    row₁ = min(row + w, row_max)
    col₁ = min(col + w, col_max)

    return row₀, col₀, row₁, col₁
end

function μ_in_window(I::AbstractArray{T,2}, row₀::Integer, col₀::Integer, row₁::Integer, col₁::Integer) where T <: Real
    μ = boxdiff(I, row₀:row₁, col₀:col₁) / ((row₁-row₀+1)*(col₁-col₀+1))
    return μ < eps() ? 0.0 : μ
end

function σ²_in_window(I²::AbstractArray{T,2}, μ::Real, row₀::Integer, col₀::Integer, row₁::Integer, col₁::Integer) where T <: Real
    σ² = μ_in_window(I², row₀, col₀, row₁, col₁) - μ^2
    return σ² < eps() ? 0.0 : sqrt(σ²)
end

function σ_in_window(I²::AbstractArray{T,2}, μ::Real, row₀::Integer, col₀::Integer, row₁::Integer, col₁::Integer) where T <: Real
    σ² = σ²_in_window(I², μ, row₀, col₀, row₁, col₁)
    return σ² == 0 ? 0.0 : sqrt(σ²)
end
