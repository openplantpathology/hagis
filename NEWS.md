# hagis (Development version)

## New features

- Added `summarize_gene_pi()` to calculate raw-score Pathogenicity Index (PI) by gene following Herrmann et al.
  (1999), `PI = sum(scores) / (MAX * N)`.

- Added `autoplot.hagis.gene.pi()` for plotting Pathogenicity Index values as raw index or percent scale.

## Documentation

- Clarified that `summarize_gene()` provides a thresholded binary summary, while `summarize_gene_pi()` implements the paper-defined raw-score Pathogenicity Index.

## Bug fixes

- `calculate_complexities()`: Fixed a misplaced parenthesis in the frequency calculation loop where division by `n_sample * 100` was being performed inside `which()` on index integers, then discarded by `length()`.
  Stored frequency values were raw counts rather than percentages.

- `calculate_diversities()`: Fixed `N_samples` being counted after filtering to susceptible-only reactions.
  Samples resistant to every gene were silently excluded from the denominator, inflating all five diversity indices for such datasets.

- `calculate_diversities()`: Removed use of `exp(1L)` as an explicit base argument to `log()`.
  While numerically correct, passing an integer to `exp()` forced an unnecessary integer-to-double coercion on every call.
  `log()` without a base argument defaults to natural log.

- `summarize_gene()`: Fixed `percent_pathogenic` being calculated as `N_virulent_isolates / max(N_virulent_isolates) * 100`, which always produced 100% for the most virulent gene and expressed proportions relative to that gene rather than to total samples.
  Now correctly calculated as `N_virulent_isolates / N_samples * 100`.

- `summarize_gene()`, `calculate_diversities()`, `create_binary_matrix()`: Fixed inconsistent ordering where the susceptible control gene was removed after `.binary_cutoff()` rather than before, wasting computation on rows that were immediately discarded.
  Order now matches `calculate_complexities()` across all functions.

- `summarize_gene()`, `calculate_diversities()`: Fixed `N_samples` being captured after control and susceptibility filtering.
  The denominator now correctly reflects all samples in the dataset.

- `create_binary_matrix()`: Removed a redundant `melt()` call before `dcast()`.
  The data was already in long format; `melt()` only renamed the value column before `dcast()` pivoted it wide, adding a full extra pass and allocation with no benefit.

- `create_binary_matrix()`: Added `fun.aggregate = mean` to `dcast()`.
  Previously, duplicate `sample`/`gene` combinations would silently fall back to `length` as the aggregation function, producing counts instead of binary values without any warning.

- `autoplot.hagis.complexities()`, `autoplot.hagis.gene.summary()`: Fixed `.call = FALSE` in `stop()` calls, which is not a valid argument name for `stop()`.
  The correct argument is `call. = FALSE`.
  The call stack was being included in error messages against intent.

- `autoplot.hagis.complexities()`, `autoplot.hagis.gene.summary()`: Fixed duplicate `object$order` / `z$order` assignments that appeared inside each `if`/`else if` branch and were immediately overwritten by an unconditional assignment after the block.
  The in-branch assignments had no effect.

- `diversities_table()`: Replaced `class(x)[1L] != "hagis.diversities"` with `!inherits(x, "hagis.diversities")` for robustness with multi-class objects.
  Now consistent with `individual_pathotypes()`.

## Performance improvements

- `.check_inputs()`: Avoided an unnecessary deep copy when the input is already a `data.table`.
  `as.data.table()` always allocates; the function now uses `copy()` for `data.table` inputs and `as.data.table()` only for other `data.frame` subclasses.

- `.binary_cutoff()`: Replaced a two-pass column assignment (initialise to `0`, then overwrite matching rows with `1`) with a single vectorised `as.integer(perc_susc >= .cutoff)` expression.

- `calculate_complexities()`: Replaced the `for` loop, intermediate list allocation, and `utils::stack()` + factor-join chain used to build `grouped_complexities` with a single `data.table` aggregation using `.N` and inline arithmetic by group.

- `calculate_diversities()`: Replaced `split()` + `vapply()` + `toString()` for building per-sample pathotype strings with a single `data.table` group-by and `paste(sort(gene), collapse = ", ")`.
  As a side effect, gene names within each pathotype string are now sorted consistently regardless of row order in the input.

- `calculate_diversities()`: Replaced `setDT(data.frame(...))` with a direct `data.table` group-by, removing the intermediate `data.frame` allocation.

- `create_binary_matrix()`: Replaced `data.table(x[, c(...)])` column selection, which forced a redundant deep copy of an already-`data.table` object, with native `dt[, .(sample, gene, susceptible.1)]`.

## Minor improvements and cleanup

- All functions that previously reassigned the user-supplied argument `x` throughout the body now use an internal variable `dt`, avoiding silent clobbering of the input object with intermediate values.

- `autoplot.hagis.complexities()`, `autoplot.hagis.gene.summary()`: `...` is now correctly forwarded to `geom_col()` in both `plot_percentage()` and `plot_count()` helpers, consistent with the documented behaviour of the `...` argument.

- `autoplot.hagis.gene.summary()`: Replaced `ggplot2::ggtitle(expression(...))` with plain character strings.
  `expression()` is intended for plotmath notation and is misleading when wrapping ordinary text.

- `pander.summary.complexities()`, `pander.hagis.diversities()`: `caption` and `...` are now forwarded to the underlying `pander::pandoc.table()` / `pander::pander()` calls.
  Previously they were accepted by the function signature but silently dropped.

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

- Skip *ALL* tests on CRAN.
  Because, y'know, CRAN...

# hagis 3.1.9

## "Bug" fixes

- Only run plotting examples if session is interactive to "fix" a "bug" with CRAN determining that the examples suddenly take too long to run.

# hagis 3.1.8

## Bug fixes

- Fix "long running" tests.

## Minor changes

- Add Cain *et al.* paper to README.

- Minor grammar edits.

# hagis 3.1.7

## Minor changes

- Use {roxyglobals}.

- Format package names as {package name} not `package name` or *package name* in documentation.

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

- README is now more complete with information and links to the *MPMI* paper

# hagis 3.1.2

## Minor changes

- Improved documentation formatting

- Update ROxygen details

- Fixes incomplete end of line in test-create_binary_matrix.R

- Add wordlist of allowed words for spellchecking

- More consistent code styling in vignettes

- Prefer "*" to "\*" for \_italics*

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

- `plot()` is now defunct.
  Use `autoplot()` to plot {hagis} objects in place of `plot()`.
  This is to avoid the side-effect of generating and displaying a plot every time `plot()` is called, which can be troublesome when using {ggplot2} themes since it created two plots, the original with the base theme and the new themed plot

## Minor Changes

- Rename output column `N_susc` to `N_virulent_isolates`

- Don't round results from `summarize_gene()` or `calculate_complexities()` before returning values to user

- Implement fix suggested by @zkamvar to ensure that the user-input data is not changed from a `data.frame` or `tibble` object to a `data.table` object in the R session

- Add ability to sort graph x-axis in ascending or descending order based on the y-axis values rather than only by gene or complexity.

- Move example data set into internal data and provide documentation for them

- Provide documentation for how diversity indices are calculated along with mathematical notation where possible to display

- Calculate Shannon and Simpson indices internally rather than rely on {vegan} to reduce number of Dependencies

- Replace the term `field` with `column` in documentation

- Test coverage now 100 %

- Add funding agencies to DESCRIPTION [Authors\@R](mailto:Authors@R){.email} field

# hagis 2.0.0

- Initial CRAN release

- Completely new R-package format rather than just Rmd and script files

# hagis 1.0.0

- Initial release of Rmd and script files by A.
  McCoy and Z.
  Noel
