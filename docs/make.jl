using Documenter
using OmniTools

makedocs(
    modules = [OmniTools],
    sitename = "OmniTools.jl",
    format = Documenter.HTML(prettyurls = get(ENV, "CI", "") == "true"),
    pages = [
        "Home" => "index.md",
        "API" => [
            "Overview" => "api.md",
            "OmniTools (flat)" => "api/OmniTools.md",
            "ForArray" => "api/ForArray.md",
            "ForCollections" => "api/ForCollections.md",
            "ForDisplay" => "api/ForDisplay.md",
            "ForDocStrings" => "api/ForDocStrings.md",
            "ForLongTuples" => "api/ForLongTuples.md",
            "ForMethods" => "api/ForMethods.md",
            "ForNumber" => "api/ForNumber.md",
            "ForPkg" => "api/ForPkg.md",
            "ForString" => "api/ForString.md",
        ],
    ],
)

if get(ENV, "GITHUB_ACTIONS", "") == "true"
    deploydocs(
        repo = "github.com/LandEcosystems/OmniTools.jl",
        devbranch = "main",
        push_preview = true,
    )
end
