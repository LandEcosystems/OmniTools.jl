# UtilsKit.jl

[![][docs-stable-img]][docs-stable-url] [![][docs-dev-img]][docs-dev-url] [![][ci-img]][ci-url] [![][codecov-img]][codecov-url] [![Julia][julia-img]][julia-url] [![License: EUPL-1.2](https://img.shields.io/badge/License-EUPL--1.2-blue)](https://joinup.ec.europa.eu/collection/eupl/eupl-text-eupl-12)

[docs-dev-img]: https://img.shields.io/badge/docs-dev-blue.svg
[docs-dev-url]: https://LandEcosystems.github.io/UtilsKit.jl/dev/

[docs-stable-img]: https://img.shields.io/badge/docs-stable-blue.svg
[docs-stable-url]: https://LandEcosystems.github.io/UtilsKit.jl/stable/

[ci-img]: https://github.com/LandEcosystems/UtilsKit.jl/workflows/CI/badge.svg
[ci-url]: https://github.com/LandEcosystems/UtilsKit.jl/actions?query=workflow%3ACI

[codecov-img]: https://codecov.io/gh/LandEcosystems/UtilsKit.jl/branch/main/graph/badge.svg
[codecov-url]: https://codecov.io/gh/LandEcosystems/UtilsKit.jl

[julia-img]: https://img.shields.io/badge/julia-v1.6+-blue.svg
[julia-url]: https://julialang.org/

A comprehensive utility package providing foundational functions for data manipulation, collections management, display formatting, and type introspection.

## Features

- **Array Operations**: Booleanization, matrix diagonal operations, array stacking, and view operations
- **Collections Management**: Dictionary to NamedTuple conversion, NamedTuple manipulation, table operations
- **String Utilities**: Case conversion, formatting, and prefix/suffix manipulation
- **Number Utilities**: Value clamping, validation, and invalid number handling
- **Display & Formatting**: Colored terminal output, ASCII art banners, logging utilities
- **Type Introspection**: Type hierarchy exploration, docstring generation, method utilities
- **Performance**: Type-stable functions designed for performance-critical workflows

## Submodules (optional)

The package keeps a flat API for convenience (e.g. `positiveMask(...)`), but also exposes submodules:

```julia
using UtilsKit

UtilsKit.ForArray.positiveMask([1, 0, -1])
UtilsKit.ForNumber.replaceInvalidNumber(NaN, 0.0)
```

Note: long-tuple utilities live under `UtilsKit.ForLongTuples` to avoid naming conflicts with `Base` and with the exported `LongTuple` type.

## Installation

```julia
using Pkg
Pkg.add("UtilsKit")
```

## Quick Start

```julia
using UtilsKit

# Convert dictionary to NamedTuple
dict = Dict(:a => 1, :b => 2, :c => Dict(:d => 3))
nt = dictToNamedTuple(dict)

# Display a banner (FIGlet)
printFIGletBanner("UtilsKit")

# Work with arrays
arr = [1, 2, 3, 0, -1, 5]
bool_arr = positiveMask(arr)

# String utilities
str = toUpperCaseFirst("hello_world", "Time")  # Returns :TimeHelloWorld

# Generate type documentation
using UtilsKit
doc_str = getTypeDocString(SomeType)
```

## Main Functionality

### Array Operations

- `positiveMask`: Convert arrays to boolean masks
- `upperTriangleMask`, `lowerTriangleMask`, `offDiagonalMask`: Matrix mask helpers
- `offDiagonalElements`, `upperOffDiagonalElements`, `lowerOffDiagonalElements`: Extract off-diagonal elements
- `stackAsColumns`: Stack multiple arrays as columns
- `viewAtTrailingIndices`: Create array views using trailing indices

### Collections and Data Structures

- `dictToNamedTuple`: Convert nested dictionaries to NamedTuples
- `namedTupleFromNamesValues`: Create NamedTuples from names + values
- `dropNamedTupleFields`: Remove fields from NamedTuples
- `mergeNamedTuplePreferNonEmpty`: Combine NamedTuples (preferring non-empty fields)
- `tableToNamedTuple`: Convert tables to NamedTuples
- `setNamedTupleField`, `setNamedTupleSubfield`: Modify NamedTuple fields
- `listToTable`: Convert lists to a `TypedTables.Table`
- `duplicates`: Find duplicate elements

### String Utilities

- `toUpperCaseFirst`: Convert strings to camelCase/PascalCase

### Number Utilities

- `clampZeroOne`: Clamp values between 0 and 1
- `atLeastZero`, `atLeastOne`, `atMostZero`, `atMostOne`: Value limiting functions
- `isInvalidNumber`: Check for invalid numbers
- `replaceInvalidNumber`: Replace invalid values
- `getFrac`: Get fractional part
- `cumSum!`: In-place cumulative sum

### Display and Formatting

- `printFIGletBanner`: Display ASCII art banners (FIGlet)
- `printInfo`: Display formatted information
- `printInfoSeparator`: Display separators
- `setLogLevel`: Configure logging levels
- `toggleTypeAbbrevInStacktrace`: Toggle stack trace display

### Type and Documentation Utilities

- `getTypeDocString`: Generate formatted docstrings for types
- `writeTypeDocString`: Write type docstrings to files
- `loopWriteTypeDocString`: Batch write type docstrings

## Dependencies

- `Accessors`: Nested data structure access
- `Crayons`: Colored terminal output
- `DataStructures`: Collection utilities
- `FIGlet`: ASCII art generation
- `InteractiveUtils`: REPL utilities
- `Logging`: Logging framework
- `StyledStrings`: Styled text output
- `TypedTables`: Typed table structures

## Documentation

For detailed documentation, see the [UtilsKit.jl documentation][docs-stable-url].

## License

This package is licensed under the EUPL-1.2 (European Union Public Licence v. 1.2). See the [LICENSE](LICENSE) file for details.

## Contributing

Contributions are welcome! Please open an issue or pull request in this repository.

## Authors

UtilsKit.jl Contributors
