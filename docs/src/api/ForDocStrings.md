```@meta
CurrentModule = OmniTools
```

# OmniTools.ForDocStrings

## Exported

```@docs
ForDocStrings.get_type_docstring
```

::: details Code

```julia
function get_type_docstring(typ::Type; purpose_function=purpose)
    doc_string = ""
    doc_string *= "\n# $(nameof(typ))\n\n"
    doc_string *= "$(purpose_function(typ))\n\n"
    doc_string *= "## Type Hierarchy\n\n"
    doc_string *= "```$(join(nameof.(supertypes(typ)), " <: "))```\n\n"
    sub_types = subtypes(typ)
    if length(sub_types) > 0
        doc_string *= "-----\n\n"
        doc_string *= "# Extended help\n\n"
        doc_string *= "## Available methods/subtypes:\n"
        doc_string *= "$(methods_of(typ, is_subtype=true, purpose_function=purpose_function))\n\n"
    end
    return doc_string
end
```

:::

```@docs
ForDocStrings.loop_write_type_docstring
```

::: details Code

```julia
 function loop_write_type_docstring(io, typ; purpose_function=purpose)
    write_type_docstring(io, typ, purpose_function=purpose_function)
    sub_types = subtypes(typ)
    for sub_type in sub_types
       io = loop_write_type_docstring(io, sub_type, purpose_function=purpose_function)
    end
    return io
 end
```

:::

```@docs
ForDocStrings.write_type_docstring
```

::: details Code

```julia
function write_type_docstring(io, typ; purpose_function=purpose)
    doc_string = base_doc(typ)
    if startswith(string(doc_string), "No documentation found for public symbol")
       write(io, "@doc \"\"\"\n$(get_type_docstring(typ, purpose_function=purpose_function))\n\"\"\"\n")
    #    write(o_file, "$(nameof(T))\n\n")
       write(io, "$(typ)\n\n")
    # else
        # write(o_file, "$(T)\n\n")
        # println("Doc string already exists for $(T), $(doc_string)")
    end
    return io
 end

"""
    loop_write_type_docstring(o_file, T)

Write a docstring for a type to a file.

# Description
This function writes a docstring for a type to a file.

# Arguments
- `o_file`: The file to write the docstring to
- `T`: The type for which the docstring is to be generated

# Returns
- `o_file`: The file with the docstring written to it

# Examples

```jldoctest
julia> using OmniTools

julia> io = IOBuffer();

julia> abstract type _TmpNoDocAbstract end;

julia> loop_write_type_docstring(io, _TmpNoDocAbstract) === io
true
```

"""
 function loop_write_type_docstring(io, typ; purpose_function=purpose)
    write_type_docstring(io, typ, purpose_function=purpose_function)
    sub_types = subtypes(typ)
    for sub_type in sub_types
       io = loop_write_type_docstring(io, sub_type, purpose_function=purpose_function)
    end
    return io
 end

end # module ForDocStrings

```

:::

## Internal

```@autodocs
Modules = [OmniTools.ForDocStrings]
Public = false
Private = true
Order = [:module, :type, :function]
```
