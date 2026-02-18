using DocumenterVitepress
using Documenter
using OmniTools

# Generate API pages with code sections before building docs
include(joinpath(@__DIR__, "gen_api_md.jl"))

makedocs(;
    sitename = "OmniTools.jl",
    authors = "OmniTools.jl Contributors",
    clean = true,
    format = DocumenterVitepress.MarkdownVitepress(
        repo = "github.com/LandEcosystems/OmniTools.jl",
    ),
    remotes = nothing,
    draft = false,
    warnonly = true,
    source = "src",
    build = "build",
)

DocumenterVitepress.deploydocs(;
    repo = "github.com/LandEcosystems/OmniTools.jl",
    target = joinpath(@__DIR__, "build"),
    branch = "gh-pages",
    devbranch = "main",
    push_preview = true
)
