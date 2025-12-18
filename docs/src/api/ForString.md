```@meta
CurrentModule = OmniTools
```

# OmniTools.ForString

## Exported

```@docs
ForString.to_uppercase_first
```

::: details Code

```julia
function to_uppercase_first(str::AbstractString, prefix::AbstractString="")
    str_s = Base.String(str)
    prefix_s = Base.String(prefix)
    return Symbol(prefix_s * join(uppercasefirst.(split(str_s, "_"))))
end
```

:::

## Internal

```@autodocs
Modules = [OmniTools.ForString]
Public = false
Private = true
Order = [:module, :type, :function]
```
