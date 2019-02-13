
#utility function for AdaptiveThreshold
function get_s(img::AbstractArray)
    s = div(div((size(img)[2]+size(img)[1]),2),8)
    s
end
