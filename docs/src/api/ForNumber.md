```@meta
CurrentModule = OmniTools
```

# OmniTools.ForNumber

## Exported

```@docs
ForNumber.at_least_one
```

::: details Code

```julia
function at_least_one(num)
    return max(num, one(num))
end
```

:::

```@docs
ForNumber.at_least_zero
```

::: details Code

```julia
function at_least_zero(num)
    return max(num, zero(num))
end
```

:::

```@docs
ForNumber.at_most_one
```

::: details Code

```julia
function at_most_one(num)
    return min(num, one(num))
end
```

:::

```@docs
ForNumber.at_most_zero
```

::: details Code

```julia
function at_most_zero(num)
    return min(num, zero(num))
end
```

:::

```@docs
ForNumber.clamp_zero_one
```

::: details Code

```julia
function clamp_zero_one(num)
    return clamp(num, zero(num), one(num))
end
```

:::

```@docs
ForNumber.cumulative_sum!
```

::: details Code

```julia
function cumulative_sum!(output::AbstractVector, input::AbstractVector)
    for i ∈ eachindex(input)
        output[i] = sum(input[1:i])
    end
    return output
end
```

:::

```@docs
ForNumber.is_invalid_number
```

::: details Code

```julia
function is_invalid_number(x)
    return isnothing(x) || ismissing(x) || isnan(x) || isinf(x)
end
```

:::

```@docs
ForNumber.replace_invalid_number
```

::: details Code

```julia
function replace_invalid_number(x, fill_value)
    x = is_invalid_number(x) ? fill_value : x
    return x
end
```

:::

```@docs
ForNumber.safe_divide
```

::: details Code

```julia
function safe_divide(numerator, denominator)
    if !iszero(denominator)
        ratio = numerator / denominator
    else
        ratio = numerator
    end
    return ratio
end
```

:::

## Internal

```@autodocs
Modules = [OmniTools.ForNumber]
Public = false
Private = true
Order = [:module, :type, :function]
```
