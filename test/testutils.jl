# AbstractGray and Color3 tests should be generated seperately
function generate_test_types(number_types::AbstractArray{<:DataType}, color_types::AbstractArray{<:UnionAll})
    test_types = map(Iterators.product(number_types, color_types)) do T
        try
            T[2]{T[1]}
        catch err
            !isa(err, TypeError) && rethrow(err)
        end
    end
    test_types = filter(x->x != false, test_types)
    if isempty(filter(x->x<:Color3, test_types))
        test_types = [number_types..., test_types...]
    end
    test_types
end

function binarization_equality(ratio = 0.01)
    function (ref, x)
        count = sum(ref .!= x)
        max_count = ceil(Int, length(ref)*ratio)
        rst = count <= max_count
        if !rst
            @warn "$count pixels are incorrectly binarized, at most $max_count is allowed."
        end
        return rst
    end
end
