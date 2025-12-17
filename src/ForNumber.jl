"""
    UtilsKit.ForNumber

Number utilities:
- clamping and min/max helpers
- invalid-number detection (`nothing`/`missing`/`NaN`/`Inf`)
- invalid-value replacement and simple helpers like cumulative sum
"""
module ForNumber

export clampZeroOne
export cumSum!
export getFrac
export isInvalidNumber
export atLeastZero, atLeastOne, atMostZero, atMostOne
export replaceInvalidNumber

"""
    clampZeroOne(num)

returns max(min(num, 1), 0)

# Examples

```jldoctest
julia> using UtilsKit

julia> clampZeroOne(2.0)
1.0

julia> clampZeroOne(-0.5)
0.0
```
"""
function clampZeroOne(num)
    return clamp(num, zero(num), one(num))
end

"""
    cumSum!(i_n::AbstractVector, o_ut::AbstractVector)

fill out the output vector with the cumulative sum of elements from input vector

# Examples

```jldoctest
julia> using UtilsKit

julia> out = zeros(Int, 3);

julia> cumSum!([1, 2, 3], out)
3-element Vector{Int64}:
 1
 3
 6
```
"""
function cumSum!(input::AbstractVector, output::AbstractVector)
    for i ∈ eachindex(input)
        output[i] = sum(input[1:i])
    end
    return output
end



"""
    getFrac(num, den)

return either a ratio or numerator depending on whether denomitor is a zero

# Examples

```jldoctest
julia> using UtilsKit

julia> getFrac(1.0, 2.0)
0.5

julia> getFrac(1.0, 0.0)
1.0
```
"""
function getFrac(numerator, denominator)
    if !iszero(denominator)
        ratio = numerator / denominator
    else
        ratio = numerator
    end
    return ratio
end


"""
    isInvalidNumber(_data::Number)

Checks if a number is invalid (e.g., `nothing`, `missing`, `NaN`, or `Inf`).

# Arguments:
- `_data`: The input number.

# Returns:
`true` if the number is invalid, otherwise `false`.

# Examples

```jldoctest
julia> using UtilsKit

julia> isInvalidNumber(NaN)
true

julia> isInvalidNumber(1.0)
false
```
"""
function isInvalidNumber(x)
    return isnothing(x) || ismissing(x) || isnan(x) || isinf(x)
end



"""
    atLeastZero(num)

returns max(num, 0)

# Examples

```jldoctest
julia> using UtilsKit

julia> atLeastZero(-1.0)
0.0
```
"""
function atLeastZero(num)
    return max(num, zero(num))
end


"""
    atLeastOne(num)

returns max(num, 1)

# Examples

```jldoctest
julia> using UtilsKit

julia> atLeastOne(0.5)
1.0
```
"""
function atLeastOne(num)
    return max(num, one(num))
end


"""
    atMostZero(num)

returns min(num, 0)

# Examples

```jldoctest
julia> using UtilsKit

julia> atMostZero(1.0)
0.0
```
"""
function atMostZero(num)
    return min(num, zero(num))
end


"""
    atMostOne(num)

returns min(num, 1)

# Examples

```jldoctest
julia> using UtilsKit

julia> atMostOne(2.0)
1.0
```
"""
function atMostOne(num)
    return min(num, one(num))
end


"""
    replaceInvalidNumber(_data, _data_fill)

Replaces invalid numbers in the input with a specified fill value.

# Arguments:
- `_data`: The input number.
- `_data_fill`: The value to replace invalid numbers with.

# Returns:
The input number if valid, otherwise the fill value.

# Examples

```jldoctest
julia> using UtilsKit

julia> replaceInvalidNumber(NaN, 0.0)
0.0

julia> replaceInvalidNumber(2.0, 0.0)
2.0
```
"""
function replaceInvalidNumber(x, fill_value)
    x = isInvalidNumber(x) ? fill_value : x
    return x
end

end # module ForNumber
