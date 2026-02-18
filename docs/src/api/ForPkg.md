```@meta
CurrentModule = OmniTools
```

# OmniTools.ForPkg

## Exported

```@docs
ForPkg.add_extension_to_function
```

::: details Code

```julia
function add_extension_to_function(target_function::Function, external_package::String; extension_location::Symbol = :Folder)
    _logStep("add_extension_to_function", "Starting (external_package=$(external_package), extension_location=$(extension_location))")

    local_module = parentmodule(target_function)
    root_pkg = Base.moduleroot(local_module)
    root_pkg_name = String(nameof(root_pkg))
    ext_module_name = "$(root_pkg_name)$(external_package)Ext"

    root_path = pathof(root_pkg)
    isnothing(root_path) && error("Cannot locate package root for $(root_pkg). Ensure it is a package module with a valid `pathof`.")
    package_root = joinpath(dirname(root_path), "..")

    # First step: ensure the weak dependency is addable/added. If this fails, we stop here and do NOT
    # create any files/directories under `ext/`.
    _ensureProjectExtensionMapping(package_root, external_package, ext_module_name)

    ext_dir = _ensureExtDir(package_root)
    ext_path = extension_location === :File ? ext_dir :
               extension_location === :Folder ? _ensureExtensionFolder(ext_dir, ext_module_name) :
               error("Invalid `extension_location=$(extension_location)`. Expected :File or :Folder.")

    # Inner module inference (single level)
    root_full = Base.fullname(root_pkg)
    fn_mod = parentmodule(target_function)
    fn_full = Base.fullname(fn_mod)
    rel = (length(fn_full) > length(root_full) && fn_full[1:length(root_full)] == root_full) ? fn_full[length(root_full)+1:end] : ()
    inner = length(rel) == 1 ? String(rel[1]) : nothing

    fn_name = String(nameof(target_function))
    cap_name = uppercasefirst(fn_name)
    codefile = isnothing(inner) ? "$(root_pkg_name)$(cap_name).jl" : "$(inner)$(cap_name).jl"

    entry_file = joinpath(ext_path, "$(ext_module_name).jl")
    code_path = joinpath(ext_path, codefile)
    entry_exists = isfile(entry_file)
    code_exists = isfile(code_path)

    # Method signature strings (dedup default-arg expansions + repo-relative paths)
    template_methods = get_method_signatures(target_function; path=:relative_root)
    # Arg name + last-arg type inference (best-effort)
    template_arg_names, template_last_arg_type = _inferCommonArgNames(target_function)

    if entry_exists && code_exists
        error("Both extension entry and include exist.\nEntry: $(entry_file)\nInclude: $(code_path)\nDelete the include file to regenerate it.")
    elseif entry_exists && !code_exists
        _warnStep("add_extension_to_function", "Entry exists but include is missing. Creating include only (no overwrite of entry).")
        _writeExtensionInclude(ext_path, codefile; template=(;
            root_package_name=root_pkg_name,
            inner_module=inner,
            external_package_name=external_package,
            function_name=fn_name,
            methods=template_methods,
            arg_names=template_arg_names,
            last_arg_type=template_last_arg_type,
        ))
    elseif !entry_exists && code_exists
        _warnStep("add_extension_to_function", "Include exists but entry is missing. Creating entry that includes existing include (no changes to include).")
        _writeExtensionEntry(root_pkg_name, inner, external_package, ext_path, ext_module_name, codefile)
    else
        _writeExtensionEntry(root_pkg_name, inner, external_package, ext_path, ext_module_name, codefile)
        _writeExtensionInclude(ext_path, codefile; template=(;
            root_package_name=root_pkg_name,
            inner_module=inner,
            external_package_name=external_package,
            function_name=fn_name,
            methods=template_methods,
            arg_names=template_arg_names,
            last_arg_type=template_last_arg_type,
        ))
    end

    _logStep("add_extension_to_function", "Done. Extension module name: $(ext_module_name)")
    return ext_module_name
end
```

:::

```@docs
ForPkg.add_extension_to_package
```

::: details Code

```julia
function add_extension_to_package(local_module::Module, external_package::String; extension_location::Symbol = :File)
    _logStep("add_extension_to_package", "Starting (external_package=$(external_package), extension_location=$(extension_location))")

    root_pkg = Base.moduleroot(local_module)
    root_pkg_name = String(nameof(root_pkg))
    ext_module_name = "$(root_pkg_name)$(external_package)Ext"

    root_path = pathof(root_pkg)
    isnothing(root_path) && error("Cannot locate package root for $(root_pkg). Ensure it is a package module with a valid `pathof`.")
    package_root = joinpath(dirname(root_path), "..")

    # First step: ensure the weak dependency is addable/added. If this fails, we stop here and do NOT
    # create any files/directories under `ext/`.
    _ensureProjectExtensionMapping(package_root, external_package, ext_module_name)

    ext_dir = _ensureExtDir(package_root)
    ext_path = extension_location === :File ? ext_dir :
               extension_location === :Folder ? _ensureExtensionFolder(ext_dir, ext_module_name) :
               error("Invalid `extension_location=$(extension_location)`. Expected :File or :Folder.")

    # Optional single inner module name for import statement
    root_full = Base.fullname(root_pkg)
    local_full = Base.fullname(local_module)
    rel = (length(local_full) > length(root_full) && local_full[1:length(root_full)] == root_full) ? local_full[length(root_full)+1:end] : ()
    inner = length(rel) == 1 ? String(rel[1]) : nothing

    _writeExtensionEntry(root_pkg_name, inner, external_package, ext_path, ext_module_name, nothing)
    _logStep("add_extension_to_package", "Done. Extension module name: $(ext_module_name)")
    return ext_module_name
end
```

:::

```@docs
ForPkg.add_package
```

::: details Code

```julia
function add_package(target, package_name)

    from_where = dirname(Base.active_project())
    dir_target = joinpath(dirname(pathof(target)), "../")
    cd(dir_target)
    StdPkg.activate(dir_target)
    is_installed = any(dep.name == package_name for dep in values(StdPkg.dependencies()))

    if is_installed
        @info "$package_name is already installed in $target. Nothing to do. Return to base environment at $from_where".
    else

        StdPkg.add(package_name)
        rm("Manifest.toml")
        StdPkg.instantiate()
        @info "Added $(package_name) to $(target). Add the following to the imports in $(pathof(target)) with\n\nusing $(package_name)\n\n. You may need to restart the REPL/environment at $(from_where)."
    end
    cd(from_where)
    StdPkg.activate(from_where)
    StdPkg.resolve()
end
```

:::

```@docs
ForPkg.remove_extension_from_package
```

::: details Code

```julia
function remove_extension_from_package(local_module::Module, external_package::String)
    _logStep("remove_extension_from_package", "Starting (external_package=$(external_package))")

    root_pkg = Base.moduleroot(local_module)
    root_pkg_name = String(nameof(root_pkg))
    ext_module_name = "$(root_pkg_name)$(external_package)Ext"

    root_path = pathof(root_pkg)
    isnothing(root_path) && error("Cannot locate package root for $(root_pkg).")
    package_root = joinpath(dirname(root_path), "..")
    ext_dir = joinpath(package_root, "ext")

    file_entry = joinpath(ext_dir, "$(ext_module_name).jl")
    folder_entry = joinpath(ext_dir, ext_module_name, "$(ext_module_name).jl")
    ext_folder = joinpath(ext_dir, ext_module_name)
    file_exists = isfile(file_entry)
    folder_exists = isfile(folder_entry)

    project_file = joinpath(package_root, "Project.toml")
    project = TOML.parsefile(project_file)

    if haskey(project, "extensions") && haskey(project["extensions"], ext_module_name)
        delete!(project["extensions"], ext_module_name)
        _logStep("remove_extension_from_package", "Removed [extensions] mapping: $(ext_module_name) = \"$(external_package)\"")
    else
        _warnStep("remove_extension_from_package", "No [extensions] mapping found for $(ext_module_name).")
    end
    if haskey(project, "extensions") && haskey(project["extensions"], external_package) && project["extensions"][external_package] == ext_module_name
        delete!(project["extensions"], external_package)
        _logStep("remove_extension_from_package", "Removed reversed mapping: $(external_package) = \"$(ext_module_name)\"")
    end
    if haskey(project, "weakdeps") && haskey(project["weakdeps"], external_package)
        delete!(project["weakdeps"], external_package)
        _logStep("remove_extension_from_package", "Removed [weakdeps] entry for $(external_package).")
    end
    if haskey(project, "deps") && haskey(project["deps"], external_package)
        delete!(project["deps"], external_package)
        _warnStep("remove_extension_from_package", "Removed [deps] entry for $(external_package).")
    end

    open(project_file, "w") do io
        TOML.print(io, project)
    end
    _logStep("remove_extension_from_package", "Wrote: $(project_file)")

    try
        StdPkg.activate(package_root)
        try
            StdPkg.rm(external_package)
            _logStep("remove_extension_from_package", "Ran Pkg.rm(\"$(external_package)\") (Manifest updated).")
        catch
            _warnStep("remove_extension_from_package", "Pkg.rm(\"$(external_package)\") failed (maybe not installed).")
        end
        try StdPkg.resolve() catch end
    catch
        _warnStep("remove_extension_from_package", "Pkg environment update failed; Manifest may be unchanged.")
    end

    if file_exists && folder_exists
        _warnStep("remove_extension_from_package", "Both file- and folder-style entries exist. Remove one (or both):")
        _warnStep("remove_extension_from_package", "  ; rm -f \"$(file_entry)\"")
        _warnStep("remove_extension_from_package", "  ; rm -rf \"$(ext_folder)\"")
    elseif folder_exists
        _warnStep("remove_extension_from_package", "Detected folder-style extension. Remove with:\n  ; rm -rf \"$(ext_folder)\"")
    elseif file_exists
        _warnStep("remove_extension_from_package", "Detected file-style extension. Remove with:\n  ; rm -f \"$(file_entry)\"")
    else
        _warnStep("remove_extension_from_package", "No extension entry found under ext/. Potential commands:")
        _warnStep("remove_extension_from_package", "  ; rm -f \"$(file_entry)\"")
        _warnStep("remove_extension_from_package", "  ; rm -rf \"$(ext_folder)\"")
    end

    _logStep("remove_extension_from_package", "Done. Extension module name: $(ext_module_name)")
    return ext_module_name
end
```

:::

## Internal

```@autodocs
Modules = [OmniTools.ForPkg]
Public = false
Private = true
Order = [:module, :type, :function]
```
