"""
    UtilsKit

A comprehensive utility package providing foundational functions for data manipulation, collections management, display formatting, and type introspection.

# Overview

`UtilsKit` serves as a core utility library that provides reusable functions for common programming tasks. It is designed to be type-stable and performant.

# Main Features

## Array Operations
- Array booleanization and masking
- Matrix diagonal operations (upper, lower, off-diagonal)
- Array stacking and view operations
- Invalid value handling and replacement

## Collections and Data Structures
- Dictionary to NamedTuple conversion
- NamedTuple manipulation (field dropping, combining, setting)
- Table to NamedTuple conversion
- List tabularization
- Unique/non-unique element detection

## String Utilities
- String case conversion and formatting
- Prefix/suffix manipulation

## Number Utilities
- Value clamping and validation
- Invalid number detection and replacement
- Fractional and cumulative sum operations

## Display and Formatting
- Colored terminal output with `Crayons`
- ASCII art banners with `FIGlet`
- Logging level management
- Type information display with color coding
- Banner and separator display functions

## Type and Method Utilities
- Type introspection and hierarchy exploration
- Docstring generation for types
- Method manipulation utilities
- Long tuple handling

## Documentation Utilities
- Automated docstring generation
- Type documentation formatting
- Purpose function integration

# Dependencies

- `Accessors`: Utilities for accessing and modifying nested data structures
- `Crayons`: Colored terminal output
- `DataStructures`: Data structure utilities for collections
- `FIGlet`: ASCII art text generation
- `InteractiveUtils`: Interactive utilities for Julia REPL
- `Logging`: Logging framework
- `TypedTables`: Typed table data structures

# Usage Example

```julia
using UtilsKit

# Convert dictionary to NamedTuple
dict = Dict(:a => 1, :b => 2)
nt = dictToNamedTuple(dict)

# Display a banner (FIGlet)
printFIGletBanner("UtilsKit")

# Work with arrays
arr = [1, 2, 3, 0, -1, 5]
bool_arr = positiveMask(arr)

# String utilities
str = toUpperCaseFirst("hello_world", "Time")  # Returns :TimeHelloWorld
```

# Notes

- Functions are designed to be type-stable for performance-critical workflows
- The package provides foundational utilities intended for reuse across packages
- Display utilities support both colored and plain text output
- NamedTuple utilities enable efficient manipulation of structured data types

# See Also

- [`dictToNamedTuple`](@ref) for dictionary conversion
- [`printFIGletBanner`](@ref) for ASCII art display
- [`positiveMask`](@ref) for array masking
- [`getTypeDocString`](@ref) for type documentation generation
"""
module UtilsKit

   # Submodules (file-per-area)
   include("ForNumber.jl")       # UtilsKit.ForNumber
   include("ForString.jl")       # UtilsKit.ForString
   include("ForMethods.jl")      # UtilsKit.ForMethods
   include("ForDocStrings.jl")   # UtilsKit.ForDocStrings
   include("ForCollections.jl")  # UtilsKit.ForCollections
   include("ForLongTuples.jl")   # UtilsKit.ForLongTuples
   include("ForArray.jl")        # UtilsKit.ForArray
   include("ForDisplay.jl")      # UtilsKit.ForDisplay
   include("ForPkg.jl")          # UtilsKit.ForPkg

   # -----------------------------------------------------------------------
   # Backward-compatible flat API (re-export from submodules)
   # -----------------------------------------------------------------------

   # Number
   using .ForNumber: clampZeroOne, cumSum!, getFrac, isInvalidNumber, replaceInvalidNumber, atLeastZero, atLeastOne, atMostZero, atMostOne
   export clampZeroOne, cumSum!, getFrac, isInvalidNumber, replaceInvalidNumber, atLeastZero, atLeastOne, atMostZero, atMostOne

   # String
   using .ForString: toUpperCaseFirst
   export toUpperCaseFirst

   # Methods / introspection
   using .ForMethods: doNothing, getMethodTypes, getDefinitions, getMethodSignatures, methodsOf, printMethodSignatures, purpose, showMethodsOf, valToSymbol
   export doNothing, getMethodTypes, getDefinitions, getMethodSignatures, methodsOf, printMethodSignatures, purpose, showMethodsOf, valToSymbol

   # Docstrings
   using .ForDocStrings: loopWriteTypeDocString, writeTypeDocString, getTypeDocString
   export loopWriteTypeDocString, writeTypeDocString, getTypeDocString

   # Collections / NamedTuple utils
   using .ForCollections: dictToNamedTuple, mergeNamedTuple, tcPrint,
                          dropNamedTupleFields, foldlTupleUnrolled, mergeNamedTuplePreferNonEmpty, tableToNamedTuple,
                          namedTupleFromNamesValues, duplicates, dropEmptyNamedTupleFields,
                          setNamedTupleField, setNamedTupleSubfield, listToTable
   export dictToNamedTuple, mergeNamedTuple, tcPrint,
          dropNamedTupleFields, foldlTupleUnrolled, mergeNamedTuplePreferNonEmpty, tableToNamedTuple,
          namedTupleFromNamesValues, duplicates, dropEmptyNamedTupleFields,
          setNamedTupleField, setNamedTupleSubfield, listToTable

   # Long tuple utilities
   using .ForLongTuples: LongTuple, foldlLongTuple, toTuple, toLongTuple
   export LongTuple, foldlLongTuple, toTuple, toLongTuple

   # Arrays
   using .ForArray: positiveMask, lowerTriangleMask, offDiagonalMask, upperTriangleMask,
                    viewAtTrailingIndices, offDiagonalElements, upperOffDiagonalElements, lowerOffDiagonalElements,
                    stackAsColumns
   export positiveMask, lowerTriangleMask, offDiagonalMask, upperTriangleMask,
          viewAtTrailingIndices, offDiagonalElements, upperOffDiagonalElements, lowerOffDiagonalElements,
          stackAsColumns

   # Display helpers
   using .ForDisplay: setLogLevel, printFIGletBanner, printInfo, printInfoSeparator, toggleTypeAbbrevInStacktrace
   export setLogLevel, printFIGletBanner, printInfo, printInfoSeparator, toggleTypeAbbrevInStacktrace

   # Pkg / extensions helpers
   using .ForPkg: addExtensionToFunction, addExtensionToPackage, addPackage, removeExtensionFromPackage
   export addExtensionToFunction, addExtensionToPackage, addPackage, removeExtensionFromPackage

end # module UtilsKit
