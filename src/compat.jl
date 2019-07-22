"""
    _colon(I, J)

`_colon(I, J)` works equivelently to `I:J`, it's used to backward support julia v"1.0".
"""
_colon(I, J) = I:J
if v"1.0" <= VERSION < v"1.1"
    _colon(I::CartesianIndex{N}, J::CartesianIndex{N}) where N =
        CartesianIndices(map((i,j) -> i:j, Tuple(I), Tuple(J)))
end
