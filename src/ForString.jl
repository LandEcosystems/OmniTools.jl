"""
    OmniTools.ForString

String utilities (kept in a separate submodule to avoid Base name conflicts).
Currently includes helpers for converting snake_case strings to `Symbol`s.
"""
module ForString

export normalize_path_separator
export to_uppercase_first

"""
    to_uppercase_first(s::AbstractString, prefix="")

Converts the first letter of each word in a string to uppercase, removes underscores, and adds a prefix.

# Arguments:
- `s`: The input string.
- `prefix`: A prefix to add to the resulting string (default: "").

# Returns:
A `Symbol` with the transformed string.

# Examples

```jldoctest
julia> using OmniTools

julia> to_uppercase_first("hello_world", "Time")
:TimeHelloWorld
```
"""
function to_uppercase_first(str::AbstractString, prefix::AbstractString="")
    str_s = Base.String(str)
    prefix_s = Base.String(prefix)
    return Symbol(prefix_s * join(uppercasefirst.(split(str_s, "_"))))
end

"""
    normalize_path_separator(path::AbstractString)
Normalizes a file path by replacing backslashes with forward slashes and collapsing multiple slashes.
# Arguments:
- `path`: The input file path as a string.
# Returns:
A normalized file path string.
# Examples
```jldoctest
julia> using OmniTools
julia> normalize_path_separator("C:\\Users\\Example\\Documents\\\\file.txt")
"C:/Users/Example/Documents/file.txt"
```
"""
function normalize_path_separator(path::AbstractString)
    # Replace backslashes with forward slashes
    p = replace(path, '\\' => '/')

    # Collapse accidental double slashes (except protocol prefixes like http://)
    p = replace(p, r"(?<!:)/{2,}" => "/")

    return p
end
end # module ForString
