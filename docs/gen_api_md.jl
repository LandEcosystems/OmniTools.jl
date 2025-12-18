using Pkg
cd(@__DIR__)
Pkg.activate(".")

using OmniTools
using InteractiveUtils

# Get the source directory
src_dir = joinpath(@__DIR__, "..", "src")

# Function to extract function code from a source file
function extract_function_code(file_path::String, func_name::String)
    code = read(file_path, String)
    lines = split(code, '\n')
    
    # Find the function definition - look for "function func_name" 
    func_pattern = Regex("^\\s*function\\s+$func_name")
    
    function_start = nothing
    for (i, line) in enumerate(lines)
        if occursin(func_pattern, line)
            function_start = i
            break
        end
    end
    
    if function_start === nothing
        return nothing
    end
    
    # Extract function body until matching 'end' at same or less indentation
    function_lines = String[]
    start_line = lines[function_start]
    start_indent_match = match(r"^(\s*)", start_line)
    base_indent = start_indent_match === nothing ? 0 : length(start_indent_match.captures[1])
    
    for i in function_start:length(lines)
        line = lines[i]
        push!(function_lines, line)
        
        # Check for 'end' at the same or less indentation (but not the first line)
        if i > function_start
            end_match = match(r"^(\s*)end\s*$", line)
            if end_match !== nothing
                end_indent = length(end_match.captures[1])
                if end_indent <= base_indent
                    break
                end
            end
        end
    end
    
    result = join(function_lines, '\n')
    return strip(result) == "" ? nothing : result
end

# Function to get all exported functions from a module
function get_module_functions(module_name::Symbol)
    mod = getfield(OmniTools, module_name)
    names = names(mod, all=false)  # Only exported names
    functions = Function[]
    
    for name in names
        try
            val = getfield(mod, name)
            if isa(val, Function) || (isa(val, Type) && val <: Function)
                push!(functions, name)
            end
        catch
            continue
        end
    end
    
    return functions
end

# Generate API page for a module
function generate_module_api(module_name::Symbol, module_file::String, output_path::String)
    open(output_path, "w") do io
        write(io, "```@meta\n")
        write(io, "CurrentModule = OmniTools\n")
        write(io, "```\n\n")
        write(io, "# OmniTools.$module_name\n\n")
        write(io, "## Exported\n\n")
        write(io, "```@autodocs\n")
        write(io, "Modules = [OmniTools.$module_name]\n")
        write(io, "Public = true\n")
        write(io, "Private = false\n")
        write(io, "Order = [:module, :type, :function]\n")
        write(io, "```\n\n")
        
        # Add code sections for exported functions
        try
            mod = getfield(OmniTools, module_name)
            exported_names = names(mod, all=false)
            
            # Filter for functions
            func_names = Symbol[]
            for name in exported_names
                try
                    val = getfield(mod, name)
                    if isa(val, Function)
                        push!(func_names, name)
                    end
                catch
                    continue
                end
            end
            
            if !isempty(func_names)
                write(io, "## Function Code\n\n")
                for func_name in func_names
                    func_code = extract_function_code(module_file, string(func_name))
                    if func_code !== nothing && strip(func_code) != ""
                        write(io, "### $func_name\n\n")
                        write(io, "::: details Code\n\n")
                        write(io, "```julia\n")
                        write(io, func_code)
                        write(io, "\n```\n\n")
                        write(io, ":::\n\n")
                    end
                end
            end
        catch e
            @warn "Could not extract functions for $module_name: $e"
        end
        
        write(io, "## Internal\n\n")
        write(io, "```@autodocs\n")
        write(io, "Modules = [OmniTools.$module_name]\n")
        write(io, "Public = false\n")
        write(io, "Private = true\n")
        write(io, "Order = [:module, :type, :function]\n")
        write(io, "```\n")
    end
end

# Generate API pages for all modules
modules = [
    (:ForArray, "ForArray.jl"),
    (:ForCollections, "ForCollections.jl"),
    (:ForDisplay, "ForDisplay.jl"),
    (:ForDocStrings, "ForDocStrings.jl"),
    (:ForLongTuples, "ForLongTuples.jl"),
    (:ForMethods, "ForMethods.jl"),
    (:ForNumber, "ForNumber.jl"),
    (:ForPkg, "ForPkg.jl"),
    (:ForString, "ForString.jl"),
]

api_dir = joinpath(@__DIR__, "src", "api")
mkpath(api_dir)

for (mod_name, mod_file) in modules
    module_path = joinpath(src_dir, mod_file)
    output_path = joinpath(api_dir, "$mod_name.md")
    if isfile(module_path)
        generate_module_api(mod_name, module_path, output_path)
        println("Generated API documentation for $mod_name at: $output_path")
    end
end

# Also generate the main OmniTools API page
main_api_path = joinpath(api_dir, "OmniTools.md")
open(main_api_path, "w") do io
    write(io, "```@meta\n")
    write(io, "CurrentModule = OmniTools\n")
    write(io, "```\n\n")
    write(io, "# OmniTools (flat API)\n\n")
    write(io, "## Exported\n\n")
    write(io, "```@autodocs\n")
    write(io, "Modules = [OmniTools]\n")
    write(io, "Public = true\n")
    write(io, "Private = false\n")
    write(io, "Order = [:module, :type, :function]\n")
    write(io, "```\n\n")
    write(io, "## Internal\n\n")
    write(io, "```@autodocs\n")
    write(io, "Modules = [OmniTools]\n")
    write(io, "Public = false\n")
    write(io, "Private = true\n")
    write(io, "Order = [:module, :type, :function]\n")
    write(io, "```\n")
end

println("Generated main API documentation at: $main_api_path")
