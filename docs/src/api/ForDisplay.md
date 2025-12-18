```@meta
CurrentModule = OmniTools
```

# OmniTools.ForDisplay

## Exported

```@docs
ForDisplay.print_figlet_banner
```

::: details Code

```julia
function print_figlet_banner(disp_text="OmniTools"; color::Bool=true, n::Integer=1, pause::Real=0.1)
    n < 1 && return nothing
    for i in 1:n
        if color
            print(Crayon(; foreground=rand(0:255)), "\n")
        end
        println("######################################################################################################\n")
        FIGlet.render(disp_text, rand(figlet_fonts))
        println("######################################################################################################")
        if i < n
            sleep(pause)
        end
    end
    return nothing
end
```

:::

```@docs
ForDisplay.print_info
```

::: details Code

```julia
function print_info(func, file_name, line_number, info_message; spacer=" ", n_f=1, n_m=1, display_color=(0, 152, 221))
    func_space = spacer ^ n_f
    info_space = spacer ^ n_m
    file_link = ""
    mpi_color = (17, 102, 86)  # Default color for info messages
    if !isnothing(func)
        file_link = " $(nameof(func)) (`$(first(splitext(basename(file_name))))`.jl:$(line_number)) => "
        # display_color = (79, 255, 55)
        # display_color = :red
        display_color = (74, 192, 60)
    end
    show_str = "$(func_space)$(file_link)$(info_space)$(info_message)"

    println(_colorizeBacktickedSegments(show_str, display_color))
    # @info show_str
end
```

:::

```@docs
ForDisplay.print_info_separator
```

::: details Code

```julia
function print_info_separator(; sep_text="", sep_width=100, display_color=(223,184,21))
    if isempty(sep_text) 
        sep_text=repeat("-", sep_width)
    else
        sep_remain = (sep_width - length(sep_text))%2
        sep_text = repeat("-", div(sep_width - length(sep_text) + sep_remain, 2)) * sep_text * repeat("-", div(sep_width - length(sep_text) + sep_remain, 2))
    end
    print_info(nothing, @__FILE__, @__LINE__, "\n`$(sep_text)`\n", display_color=display_color, n_f=0, n_m=0)
end    
```

:::

```@docs
ForDisplay.set_log_level
```

::: details Code

```julia
function set_log_level()
    logger = ConsoleLogger(stderr, Logging.Info)
    global_logger(logger)
    return nothing
end
```

:::

```@docs
ForDisplay.toggle_type_abbrev_in_stacktrace
```

::: details Code

```julia
function toggle_type_abbrev_in_stacktrace(toggle=true)
    if toggle
        eval(:(Base.show(io::IO, nt::Type{<:NamedTuple}) = print(io, "NT")))
        eval(:(Base.show(io::IO, nt::Type{<:Tuple}) = print(io, "T")))
        eval(:(Base.show(io::IO, nt::Type{<:NTuple}) = print(io, "NT")))
    else
        # TODO: Restore the default behavior (currently not implemented).
        eval(:(Base.show(io::IO, nt::Type{<:NTuple}) = Base.show(io::IO, nt::Type{<:NTuple})))
    end
    return nothing
end
```

:::

## Internal

```@autodocs
Modules = [OmniTools.ForDisplay]
Public = false
Private = true
Order = [:module, :type, :function]
```
