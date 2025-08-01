# hagis 4.0.0

## Major changes

- Fixes spelling of "individual" in `hagis.complexities` objects

## Bug fixes

- Corrects cross-references in documentation to fix CRAN NOTEs as requested by CRAN maintainers on 2025-07-23.

# hagis 3.1.12

## Minor changes

- Standardise and tidy up text for functions' returned values in documentation.

## Bug fixes

- Fixes examples in "Beta-diversity Analysis with hagis" vignette to work with new versions of {vegan}.

- Corrects {vegan} example where $R^2$ was incorrectly reported.

# hagis 3.1.11

## Minor changes

- Put more guardrails in place for CRAN.
  Ensure that all tests are skipped on CRAN using a universal statement rather than `skip_on_cran()`.

- Use `data.table::setDTthreads(1L)` at the top of both vignettes.

- Use `@examplesIf interactive()` for all examples so that they don't run on CRAN.

## Bug fixes

- Removes a redundant zzz.R file that had globals in it.
  This revealed that one of the autoplot functions was missing the `@autoglobal` tag, which has been added.

# hagis 3.1.10

## Minor changes

- Skip _ALL_ tests on CRAN.
  Because, y'know, CRAN...

# hagis 3.1.9

## "Bug" fixes

- Only run plotting examples if session is interactive to "fix" a "bug" with CRAN determining that the examples suddenly take too long to run.

# hagis 3.1.8

## Bug fixes

- Fix "long running" tests.

## Minor changes

- Add Cain _et al._ paper to README.

- Minor grammar edits.

# hagis 3.1.7

## Minor changes

- Use {roxyglobals}.

- Format package names as {package name} not `package name` or _package name_ in documentation.

## Bug fixes

- Use proper title case in function titles.

# hagis 3.1.6

## Bug fixes

- Fixes bug where `.create_summary_isolate()`, an internal function, was exported.
  It should not be user-facing and is now no longer exported or documented.

# hagis 3.1.5

## Minor changes

- Improved documentation formatting.

- Improved handling of internal global variables.

- Further updates to test infrastructure.

- Update CITATION to follow CRAN's desired format.

# hagis 3.1.4

## Minor changes

- Update outdated URLs.

- Update test infrastructure.

# hagis 3.1.3

## Minor changes

- Sample names in `calculate_diversities()` are not required to be numeric values.
  Previously, this column was converted to `numeric` so if `character` values were present, these values became `NA`.
  This allows for greater flexibility when analysing the data as sample names are often more descriptive than just a numerical value.

- Spelling corrections in code comments

- Clean up CITATION file

- README is now more complete with information and links to the _MPMI_ paper

# hagis 3.1.2

## Minor changes

- Improved documentation formatting

- Update ROxygen details

- Fixes incomplete end of line in test-create_binary_matrix.R

- Add wordlist of allowed words for spellchecking

- More consistent code styling in vignettes

- Prefer "_" to "\*" for \_italics_

- More verbose handling of importing {data.table} as a whole package using "R/utils-data.table.R" in place of "R/zzz.R"

# hagis 3.1.1

## Minor Changes

- Use {ape}, {vegan}, {dplyr} and {vidiffr} packages conditionally

- Remove {covr} from Suggests

- Better documentation formatting

# hagis 3.1.0

## Major Changes

- Add new function, `create_binary_matrix()` to format data for exporting beta diversity matrices representing the pathotype of each isolate.
  Users can export a binary pathotype data matrix which could then be used to visualize beta-diversity of pathotypes using {vegan} or {ape} in R

- Add new vignette, "Beta-diversity Analyses", to illustrate the use of the new functionality

## Minor Changes

- Use ROxygen 7.1.1

- Spell check and correct spelling errors

# hagis 3.0.1

## Minor Changes

- Update citation with full MPMI citation

- Fix issue in CITATION file where {nasapower} was referred to in text

- Use ROxygen 7.0.0

- Remove an extra "/" in the CITATION's DOI

# hagis 3.0.0

## Defunct functions

- `plot()` is now defunct. Use `autoplot()` to plot {hagis} objects in place of `plot()`.
  This is to avoid the side-effect of generating and displaying a plot every time `plot()` is called, which can be troublesome when using {ggplot2} themes since it created two plots, the original with the base theme and the new themed plot

## Minor Changes

- Rename output column `N_susc` to `N_virulent_isolates`

- Don't round results from `summarize_gene()` or `calculate_complexities()`
  before returning values to user

- Implement fix suggested by @zkamvar to ensure that the user-input data is not changed from a `data.frame` or `tibble` object to a `data.table` object in the R session

- Add ability to sort graph x-axis in ascending or descending order based on the y-axis values rather than only by gene or complexity.

- Move example data set into internal data and provide documentation for them

- Provide documentation for how diversity indices are calculated along with mathematical notation where possible to display

- Calculate Shannon and Simpson indices internally rather than rely on {vegan} to reduce number of Dependencies

- Replace the term `field` with `column` in documentation

- Test coverage now 100 %

- Add funding agencies to DESCRIPTION Authors@R field

# hagis 2.0.0

- Initial CRAN release

- Completely new R-package format rather than just Rmd and script files

# hagis 1.0.0

- Initial release of Rmd and script files by A. McCoy and Z. Noel
