```@meta
CurrentModule = OmniTools
```

# OmniTools.ForCollections

## Exported

```@docs
ForCollections.dict_to_namedtuple
```

::: details Code

```julia
function dict_to_namedtuple(dict::AbstractDict)
    for k ∈ keys(dict)
        if dict[k] isa Array{Any,1}
            dict[k] = [v for v ∈ dict[k]]
        elseif dict[k] isa DataStructures.OrderedDict
            dict[k] = dict_to_namedtuple(dict[k])
        end
    end
    dict_tuple = NamedTuple{Tuple(Symbol.(keys(dict)))}(values(dict))
    return dict_tuple
end
```

:::

```@docs
ForCollections.drop_empty_namedtuple_fields
```

::: details Code

```julia
function drop_empty_namedtuple_fields(nt::NamedTuple)
    indx = findall(x -> x != NamedTuple(), values(nt))
    nkeys, nvals = tuple(collect(keys(nt))[indx]...), values(nt)[indx]
    return NamedTuple{nkeys}(nvals)
end
```

:::

```@docs
ForCollections.drop_namedtuple_fields
```

::: details Code

```julia
function drop_namedtuple_fields(nt::NamedTuple, names::Tuple{Vararg{Symbol}})
    keepnames = Base.diff_names(Base._nt_names(nt), names)
    return NamedTuple{keepnames}(nt)
end
```

:::

```@docs
ForCollections.duplicates
```

::: details Code

```julia
function duplicates(items::AbstractArray{T}) where {T}
    xs = sort(items)
    duplicatedvector = T[]
    for i ∈ eachindex(xs)[2:end]
        if (
            isequal(xs[i], xs[i-1]) &&
            (length(duplicatedvector) == 0 || !isequal(duplicatedvector[end], xs[i]))
        )
            push!(duplicatedvector, xs[i])
        end
    end
    return duplicatedvector
end
```

:::

```@docs
ForCollections.foldl_tuple_unrolled
```

```@docs
ForCollections.list_to_table
```

::: details Code

```julia
function list_to_table(list)
    table = Table((; name=[list...]))
    return table
end
```

:::

```@docs
ForCollections.merge_namedtuple
```

::: details Code

```julia
function merge_namedtuple_prefer_nonempty(base_nt::NamedTuple, priority_nt::NamedTuple)
    combined_nt = (;)
    base_fields = propertynames(base_nt)
    var_fields = propertynames(priority_nt)
    all_fields = Tuple(unique([base_fields..., var_fields...]))
    for var_field ∈ all_fields
        field_value = nothing
        if hasproperty(base_nt, var_field)
            field_value = getfield(base_nt, var_field)
        else
            field_value = getfield(priority_nt, var_field)
        end
        if hasproperty(priority_nt, var_field)
            var_prop = getfield(priority_nt, var_field)
            if !isnothing(var_prop) && length(var_prop) > 0
                field_value = getfield(priority_nt, var_field)
            end
        end
        combined_nt = set_namedtuple_field(combined_nt,
            (var_field, field_value))
    end
    return combined_nt
end
```

:::

```@docs
ForCollections.merge_namedtuple_prefer_nonempty
```

::: details Code

```julia
function merge_namedtuple_prefer_nonempty(base_nt::NamedTuple, priority_nt::NamedTuple)
    combined_nt = (;)
    base_fields = propertynames(base_nt)
    var_fields = propertynames(priority_nt)
    all_fields = Tuple(unique([base_fields..., var_fields...]))
    for var_field ∈ all_fields
        field_value = nothing
        if hasproperty(base_nt, var_field)
            field_value = getfield(base_nt, var_field)
        else
            field_value = getfield(priority_nt, var_field)
        end
        if hasproperty(priority_nt, var_field)
            var_prop = getfield(priority_nt, var_field)
            if !isnothing(var_prop) && length(var_prop) > 0
                field_value = getfield(priority_nt, var_field)
            end
        end
        combined_nt = set_namedtuple_field(combined_nt,
            (var_field, field_value))
    end
    return combined_nt
end
```

:::

```@docs
ForCollections.namedtuple_from_names_values
```

::: details Code

```julia
function namedtuple_from_names_values(values, names)
    return (; Pair.(names, values)...)
end
```

:::

```@docs
ForCollections.set_namedtuple_field
```

```@docs
ForCollections.set_namedtuple_subfield
```

::: details Code

```julia
function set_namedtuple_subfield(nt::NamedTuple, fieldname::Symbol, vals::Tuple{Symbol,Any})
    if !hasproperty(nt, fieldname)
        nt = set_namedtuple_field(nt, (fieldname, (;)))
    end
    return (; nt..., fieldname => (; getfield(nt, fieldname)..., first(vals) => last(vals)))
end
```

:::

```@docs
ForCollections.table_to_namedtuple
```

::: details Code

```julia
function table_to_namedtuple(tbl; replace_missing_values=false)
    a_nt = (;)
    for a_p in propertynames(tbl)
        t_p = getproperty(tbl, a_p)
        values_to_replace = t_p
        if replace_missing_values
            values_to_replace = [ismissing(t_p[i]) ? "" : t_p[i] for i in eachindex(t_p)]
        end
        values_to_replace = [values_to_replace...]
        a_nt = set_namedtuple_field(a_nt, (a_p, values_to_replace))
    end
    return a_nt
end
```

:::

```@docs
ForCollections.tc_print
```

::: details Code

```julia
function tc_print(data; _color=true, _type=false, _value=true, _tspace="", space_pad="")
    colors_types = _collectTypeColors(data; _color=_color)
    # aio = AnnotatedIOBuffer()
    lc = nothing
    ttf = _tspace * space_pad
    for k ∈ sort(collect(keys(data)))
        if data[k] isa NamedTuple
            tp = " = (;"
            if length(data[k]) > 0
                printstyled(Crayon(; foreground=colors_types[typeof(data[k])]), "$(k)$(tp)\n")
            else
                printstyled(Crayon(; foreground=colors_types[typeof(data[k])]), "$(k)$(tp)")
            end
            tc_print(data[k]; _color=_color, _type=_type, _value=_value, _tspace=ttf, space_pad="  ")
        else
            if _type == true
                tp = "::$(typeof(data[k]))"
                if tp == "::NT"
                    tp = "::Tuple"
                end
            else
                tp = ""
            end
            if typeof(data[k]) <: Float32
                to_print = "$(ttf) $(k) = $(data[k])f0$(tp),\n"
                if !_value
                    to_print = "$(ttf) $(k)$(tp),\n"
                end
                print(Crayon(; foreground=colors_types[typeof(data[k])]),
                    to_print)
            elseif typeof(data[k]) <: AbstractVector
                to_print = "$(ttf) $(k) = $(data[k])$(tp),\n"
                if !_value
                    to_print = "$(ttf) $(k)$(tp),\n"
                end
                print(Crayon(; foreground=colors_types[typeof(data[k])]), to_print)
            elseif typeof(data[k]) <: Matrix
                print(Crayon(; foreground=colors_types[typeof(data[k])]), "$(ttf) $(k) = [\n")
                tt_row = repeat(ttf[1], length(ttf) + 1)
                for row ∈ eachrow(data[k])
                    row_str = nothing
                    if eltype(row) == Float32
                        row_str = join(row, "f0 ") * "f0"
                    else
                        row_str = join(row, " ")
                    end
                    print(Crayon(; foreground=colors_types[typeof(data[k])]),
                        "$(tt_row) $(row_str);\n")
                end
                print(Crayon(; foreground=colors_types[typeof(data[k])]), "$(tt_row) ]$(tp),\n")
            else
                to_print = "$(ttf) $(k) = $(data[k])$(tp),"
                if !_value
                    to_print = "$(ttf) $(k)$(tp),"
                end
                print(Crayon(; foreground=colors_types[typeof(data[k])]),
                    to_print)
            end
            lc = colors_types[typeof(data[k])]
        end
        # end
        if _type == true
            _tspace = _tspace * " "
            print(Crayon(; foreground=lc), " $(ttf))::NamedTuple,\n")
        else
            if data[k] isa NamedTuple
                print(Crayon(; foreground=lc), "$(ttf)),\n")
            end
        end
    end
end
```

:::

## Internal

```@autodocs
Modules = [OmniTools.ForCollections]
Public = false
Private = true
Order = [:module, :type, :function]
```
