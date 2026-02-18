```@meta
CurrentModule = OmniTools
```

# OmniTools.ForLongTuples

## Exported

```@docs
ForLongTuples.foldl_longtuple
```

```@docs
ForLongTuples.to_longtuple
```

::: details Code

```julia
function to_longtuple(tup::Tuple, longtuple_size=5)
    longtuple_size = min(length(tup), longtuple_size)
    LongTuple{longtuple_size}(tup...)
end
```

:::

```@docs
ForLongTuples.to_tuple
```

::: details Code

```julia
function to_tuple(lt::LongTuple)
    emp_vec = []
    foreach(lt) do x
        push!(emp_vec, x)
    end
    return Tuple(emp_vec)
end
```

:::

## Internal

```@autodocs
Modules = [OmniTools.ForLongTuples]
Public = false
Private = true
Order = [:module, :type, :function]
```
