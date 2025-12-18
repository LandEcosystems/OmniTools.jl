```@meta
CurrentModule = OmniTools
```

# OmniTools.ForArray

## Exported

```@docs
ForArray.lower_off_diagonal_elements
```

::: details Code

```julia
function lower_off_diagonal_elements(A::AbstractMatrix)
    collect(@view A[[ι for ι ∈ CartesianIndices(A) if ι[1] > ι[2]]])
end
```

:::

```@docs
ForArray.lower_triangle_mask
```

::: details Code

```julia
function lower_triangle_mask(A::AbstractMatrix)
    o_mat = zeros(size(A))
    for ι ∈ CartesianIndices(A)
        if ι[1] > ι[2]
            o_mat[ι] = 1
        end
    end
    return o_mat
end
```

:::

```@docs
ForArray.off_diagonal_elements
```

::: details Code

```julia
function off_diagonal_elements(A::AbstractMatrix)
    collect(@view A[[ι for ι ∈ CartesianIndices(A) if ι[1] ≠ ι[2]]])
end
```

:::

```@docs
ForArray.off_diagonal_mask
```

::: details Code

```julia
function off_diagonal_mask(A::AbstractMatrix)
    o_mat = zeros(size(A))
    for ι ∈ CartesianIndices(A)
        if ι[1] ≠ ι[2]
            o_mat[ι] = 1
        end
    end
    return o_mat
end
```

:::

```@docs
ForArray.positive_mask
```

::: details Code

```julia
function positive_mask(arr)
    fill_value = 0.0
    arr = map(x -> replace_invalid_number(x, fill_value), arr)
    arr_bits = arr .> fill_value
    return arr_bits
end
```

:::

```@docs
ForArray.stack_as_columns
```

::: details Code

```julia
function stack_as_columns(arr)
    mat = reduce(hcat, arr)
    return length(arr[1]) == 1 ? vec(mat) : mat
end
```

:::

```@docs
ForArray.upper_off_diagonal_elements
```

::: details Code

```julia
function upper_off_diagonal_elements(A::AbstractMatrix)
    collect(@view A[[ι for ι ∈ CartesianIndices(A) if ι[1] < ι[2]]])
end
```

:::

```@docs
ForArray.upper_triangle_mask
```

::: details Code

```julia
function upper_triangle_mask(A::AbstractMatrix)
    o_mat = zeros(size(A))
    for ι ∈ CartesianIndices(A)
        if ι[1] < ι[2]
            o_mat[ι] = 1
        end
    end
    return o_mat
end
```

:::

```@docs
ForArray.view_at_trailing_indices
```

::: details Code

```julia
function view_at_trailing_indices end

function view_at_trailing_indices(data::AbstractArray{<:Any,N}, idxs::Tuple{Int}) where N
    if N == 1
        view(data, first(idxs))
    else
        dim = 1 
        d_size = size(data)
        view_inds = map(d_size) do _
            vi = dim == length(d_size) ? first(idxs) : Colon()
            dim += 1 
            vi
        end
        view(data, view_inds...)
    end
end
```

:::

## Internal

```@autodocs
Modules = [OmniTools.ForArray]
Public = false
Private = true
Order = [:module, :type, :function]
```
