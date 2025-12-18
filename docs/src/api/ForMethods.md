```@meta
CurrentModule = OmniTools
```

# OmniTools.ForMethods

## Exported

```@docs
ForMethods.do_nothing
```

::: details Code

```julia
function do_nothing(x)
    return x
end
```

:::

```@docs
ForMethods.get_definitions
```

::: details Code

```julia
function get_definitions(mod::Module, kind; internal_only=true)
    all_defined_things = filter(x -> isdefined(mod, x) && isa(getproperty(mod, x), kind), names(mod))
    defined_things = all_defined_things
    if internal_only
        defined_things = []
        for d_thing in all_defined_things
            d = getproperty(mod, d_thing)
            d_parent = parentmodule(d)
            if nameof(d_parent) == nameof(mod)
                push!(defined_things, d)
            end
        end
    end
    return defined_things
end
```

:::

```@docs
ForMethods.get_method_signatures
```

::: details Code

```julia
function get_method_signatures(f::Function; path::Symbol = :relative_pwd)
    path in (:relative_pwd, :relative_root, :absolute) ||
        error("Invalid `path=$(path)`. Expected :relative_pwd, :relative_root, or :absolute.")
    root_pkg = Base.moduleroot(parentmodule(f))
    root_path = pathof(root_pkg)
    package_root = isnothing(root_path) ? nothing : normpath(joinpath(dirname(root_path), ".."))
    pwd_root = try
        pwd()
    catch
        nothing
    end

    selected = Dict{Tuple{Any,Int,Module},Method}()
    for m in methods(f)
        key = (m.file, m.line, m.module)
        nargs = length(Base.unwrap_unionall(m.sig).parameters) - 1
        if haskey(selected, key)
            prev = selected[key]
            prev_nargs = length(Base.unwrap_unionall(prev.sig).parameters) - 1
            if nargs > prev_nargs
                selected[key] = m
            end
        else
            selected[key] = m
        end
    end

    sigs = String[]
    for m in values(selected)
        sig = Base.unwrap_unionall(m.sig)
        types = sig.parameters[2:end]
        sig_str = string(nameof(f)) * "(" * join(("::" * string(t) for t in types), ", ") * ")"

        file_str = try
            String(m.file)
        catch
            ""
        end
        loc = ""
        if !isempty(file_str)
            abs_file = try
                abspath(Base.expanduser(file_str))
            catch
                file_str
            end
            shown = if path == :absolute
                abs_file
            elseif path == :relative_root
                if isnothing(package_root)
                    abs_file
                else
                    try
                        relpath(abs_file, package_root)
                    catch
                        abs_file
                    end
                end
            else # :relative_pwd
                if isnothing(pwd_root)
                    abs_file
                else
                    try
                        relpath(abs_file, pwd_root)
                    catch
                        abs_file
                    end
                end
            end
            loc = "$(shown):$(m.line)"
        end
        # Put the location first so terminals/editors are more likely to detect a clickable `path:line` link.
        # (Some linkifiers get confused when `::Type` annotations appear before the `path:line` segment.)
        if isempty(loc)
            push!(sigs, "$(sig_str) @ $(m.module)")
        else
            push!(sigs, "$(loc)  $(sig_str) @ $(m.module)")
        end
    end
    return sigs
end
```

:::

```@docs
ForMethods.get_method_types
```

::: details Code

```julia
function get_method_types(f)
    # Get the method table for the function
    mt = methods(f)
    # Extract the types of the first method
    method_types = map(m -> Base.unwrap_unionall(m.sig).parameters[2], mt)
    return method_types
end
```

:::

```@docs
ForMethods.methods_of
```

::: details Code

```julia
function methods_of end

function methods_of(T::Type; ds="\n", is_subtype=false, bullet=" - ", purpose_function=purpose)
    sub_types = subtypes(T)
    type_name = nameof(T)
    if !is_subtype
        ds *= "## $type_name\n$(purpose_function(T))\n\n"
        ds *= "## Available methods/subtypes:\n"
    end

    if isempty(sub_types) && !is_subtype
        ds *= " - `None`\n"
    else
        for sub_type in sub_types
            sub_type_name = nameof(sub_type)
            ds *= "$bullet `$(sub_type_name)`: $(purpose_function(sub_type)) \n"
            sub_sub_types = subtypes(sub_type)
            if !isempty(sub_sub_types)
                ds = methods_of(sub_type; ds=ds, is_subtype=true, bullet="    " * bullet, purpose_function=purpose_function)
            end
        end
    end
    return ds
end
```

:::

```@docs
ForMethods.print_method_signatures
```

::: details Code

```julia
function print_method_signatures(f::Function; path::Symbol = :relative_pwd, io::IO = stdout, path_color::Symbol = :cyan)
    for s in get_method_signatures(f; path=path)
        parts = split(s, "  ", limit=2)
        if length(parts) == 2
            loc, rest = parts[1], parts[2]
            print(io, "- ")
            printstyled(io, loc; color=path_color, bold=true)
            println(io)
            println(io, "  ", rest)
        else
            println(io, "- ", s)
        end
    end
    return nothing
end
```

:::

```@docs
ForMethods.purpose
```

::: details Code

```julia
function purpose end

purpose(T) = "Undefined purpose for $(nameof(T)) of type $(typeof(T)). Add `purpose(::Type{$(nameof(T))}) = \"the_purpose\"` in appropriate function/type definition file."



"""
    val_to_symbol(val)

Returns the symbol corresponding to the type of the input value.

# Arguments:
- `val`: The input value.

# Returns:
A `Symbol` representing the type of the input value.

# Examples

```jldoctest
julia> using OmniTools

julia> val_to_symbol(Val(:x))
:x
```
"""
function val_to_symbol(x)
    return typeof(x).parameters[1]
end
```

:::

```@docs
ForMethods.show_methods_of
```

::: details Code

```julia
function show_methods_of(typ; purpose_function=Base.Docs.doc)
    println(methods_of(typ, purpose_function=purpose_function))
    return nothing
end
```

:::

```@docs
ForMethods.val_to_symbol
```

::: details Code

```julia
function val_to_symbol(x)
    return typeof(x).parameters[1]
end
```

:::

## Internal

```@autodocs
Modules = [OmniTools.ForMethods]
Public = false
Private = true
Order = [:module, :type, :function]
```
