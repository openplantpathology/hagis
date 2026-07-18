#' Check User Inputs
#'
#' Checks and validates user inputs before running functions
#'
#' @param .x a `data.table` containing the values to be summarised
#' @param .control value used to denote the susceptible control in the `gene`
#'  column. Character.
#' @param .sample column providing the unique identification for each sample
#'  being tested. Character.
#' @param .gene column providing the gene(s) being tested. Character.
#' @param .perc_susc column providing the percent susceptible reactions as a
#' numeric value. Character.
#' @autoglobal
#' @dev
.check_inputs <-
  function(.x, .control, .sample, .gene, .perc_susc) {
    .validate_input_types(.x, .control, .sample, .gene, .perc_susc)

    dt_x <- .as_data_table(.x)
    dt_x <- .rename_input_columns(dt_x, .perc_susc, .gene, .sample)

    .validate_perc_susc(dt_x)

    # set col types for the necessary cols
    dt_x[, sample := as.character(sample)]
    dt_x[, gene := as.character(gene)]

    .validate_control(dt_x, .control)

    return(dt_x[])
  }

#' Construct a Validated hagis Data Object
#'
#' Validates and standardises pathotype survey data for use with the
#' \CRANpkg{hagis} analysis functions. This constructor performs every
#' check and column-rename shared by [summarize_gene()],
#' [summarize_gene_pi()], [calculate_diversities()],
#' [calculate_complexities()], and [create_binary_matrix()], so a change
#' to input validation only ever needs to be made in one place and the
#' five analysis functions can never drift out of sync with one another.
#'
#' Note that any `cutoff`/`max_score` argument is validated separately by
#' the calling function (via `.validate_cutoff()` or its own bespoke
#' check), since that value is specific to the caller and isn't part of
#' the shape of the data itself.
#'
#' @param x a `data.frame` containing the data.
#' @param control value used to denote the susceptible control in the
#'  `gene` column. `Character`.
#' @param sample column providing the unique identification for each
#'  sample being tested. `Character`.
#' @param gene column providing the gene(s) being tested. `Character`.
#' @param perc_susc column providing the percent susceptible reactions.
#'  `Character`.
#' @returns A `hagis.data` object: a `data.table` with standardised
#'  `sample`, `gene`, and `perc_susc` columns. `control` is guaranteed to
#'  occur in the `gene` column.
#' @family hagis_data
#' @export
hagis_data <- function(x, control, sample, gene, perc_susc) {
  dt_x <- .check_inputs(
    .x = x,
    .control = control,
    .sample = sample,
    .gene = gene,
    .perc_susc = perc_susc
  )

  class(dt_x) <- union("hagis.data", class(dt_x))
  dt_x[]
}

#' Validate a Cutoff/Max-Score Argument
#'
#' Shared type-check for the raw numeric `cutoff` value used by
#' [summarize_gene()], [calculate_diversities()],
#' [calculate_complexities()], and [create_binary_matrix()]. Functions
#' that need stricter checks (e.g. [summarize_gene_pi()]'s `max_score`,
#' which must also be positive) perform their own additional validation
#' on top of this.
#'
#' @param cutoff a numeric cutoff value
#' @returns Invisibly `TRUE`, or throws an error.
#' @dev
.validate_cutoff <- function(cutoff) {
  if (is.numeric(cutoff)) {
    return(invisible(TRUE))
  }

  stop("`cutoff` must be a single numeric value.", call. = FALSE)
}

#' Validate the Types of `.check_inputs()` Arguments
#'
#' @inheritParams .check_inputs
#' @returns Invisibly `TRUE`, or throws an error.
#' @dev
.validate_input_types <- function(
  .x,
  .control,
  .sample,
  .gene,
  .perc_susc
) {
  # A vectorised all() check keeps this to a single branch, rather than a
  # chain of `||` operators (each of which is its own decision point).
  checks <- c(
    is.data.frame(.x),
    is.character(.control),
    is.character(.sample),
    is.character(.gene),
    is.character(.perc_susc)
  )

  if (all(checks)) {
    return(invisible(TRUE))
  }

  stop(
    call. = FALSE,
    "You have failed to provide all necessary inputs or\n",
    "you have provided an improperly formatted item.\n",
    "Please check and try again."
  )
}

#' Coerce Input to a data.table
#'
#' @param .x an object to coerce
#' @returns a `data.table`, copied if `.x` was already one
#' @dev
.as_data_table <- function(.x) {
  if (is.data.table(.x)) copy(.x) else as.data.table(.x)
}

#' Validate and Rename the Requested Columns
#'
#' Checks that `.perc_susc`, `.gene`, and `.sample` exist in `dt_x`, then
#' renames them to `perc_susc`, `gene`, and `sample` respectively.
#'
#' @param dt_x a `data.table`
#' @param .perc_susc,.gene,.sample column names to look for in `dt_x`
#' @returns `dt_x` with the requested columns renamed
#' @dev
.rename_input_columns <- function(dt_x, .perc_susc, .gene, .sample) {
  # Check the requested columns actually exist in `dt_x` before renaming,
  # so a typo'd column name produces a clear, package-specific error
  # rather than an opaque failure from setnames().
  requested_cols <- c(.perc_susc, .gene, .sample)
  missing_cols <- setdiff(requested_cols, names(dt_x))

  if (length(missing_cols) > 0L) {
    stop(
      call. = FALSE,
      "Column(s) not found in `x`: ",
      toString(missing_cols),
      ".\nAvailable columns are: ",
      toString(names(dt_x))
    )
  }

  setnames(dt_x, requested_cols, c("perc_susc", "gene", "sample"))
  dt_x
}

#' Validate the perc_susc Column
#'
#' @param dt_x a `data.table` already renamed by `.rename_input_columns()`
#' @returns Invisibly `TRUE`, or throws an error.
#' @dev
.validate_perc_susc <- function(dt_x) {
  # validate that perc_susc is numeric
  if (!is.numeric(dt_x$perc_susc)) {
    stop("Data in the column `perc_susc` must be numeric.", call. = FALSE)
  }

  if (any(dt_x$perc_susc < 0, na.rm = TRUE)) {
    stop(
      "Data in the column `perc_susc` must be non-negative.",
      call. = FALSE
    )
  }

  invisible(TRUE)
}

#' Validate that control Occurs in the gene Column
#'
#' Every downstream function filters out the control with
#' `gene != control`. If `.control` doesn't match anything in the gene
#' column (e.g. a typo), that filter silently becomes a no-op and the
#' control rows quietly contaminate every calculation. Catch that here
#' instead.
#'
#' @param dt_x a `data.table` already renamed by `.rename_input_columns()`
#' @param .control the control value expected to appear in `dt_x$gene`
#' @returns Invisibly `TRUE`, or throws an error.
#' @dev
.validate_control <- function(dt_x, .control) {
  if (.control %in% dt_x$gene) {
    return(invisible(TRUE))
  }

  stop(
    call. = FALSE,
    "The `control` value '",
    .control,
    "' was not found in the `gene` column.\n",
    "Please check for typos. Available gene values are: ",
    toString(unique(dt_x$gene))
  )
}

#' Validate a Single Character-String Code
#'
#' Shared type-check for a single race-code string, used by both
#' [decode_race_octal()] and [decode_race_decanary()] (their inputs are
#' validated identically before being parsed differently).
#'
#' @param code the value to validate
#' @returns Invisibly `TRUE`, or throws an error.
#' @dev
.validate_code_string <- function(code) {
  checks <- c(
    is.character(code),
    length(code) == 1L,
    !is.na(code)
  )

  if (all(checks)) {
    return(invisible(TRUE))
  }

  stop("`code` must be a single character string.", call. = FALSE)
}

#' Validate a Truncation Length
#'
#' Shared validation for the optional `n` argument used by
#' [decode_race_octal()] and [decode_race_decanary()] to truncate a
#' decoded pathotype vector back down to its original length.
#'
#' @param n the value to validate
#' @returns Invisibly `TRUE`, or throws an error.
#' @dev
.validate_truncation_length <- function(n) {
  checks <- c(
    is.numeric(n),
    length(n) == 1L,
    !is.na(n),
    n >= 1L
  )

  if (all(checks)) {
    return(invisible(TRUE))
  }

  stop("`n` must be a single positive integer.", call. = FALSE)
}

#' Create Binary Reaction Value
#'
#' Adds a column of 1 or 0 for the susceptible reaction cutoff
#'
#' @param .x A `data.table` containing the values to be summarised
#' @param .cutoff Cutoff value for susceptibility
#' @returns A `data.table` that tallies the results by gene
#' @autoglobal
#' @dev
.binary_cutoff <- function(.x, .cutoff) {
  perc_susc <- susceptible.1 <- NULL
  # Single-pass vectorised assignment: TRUE/FALSE coerced to 1/0.
  # Replaces the previous two-pass approach (init to 0, then overwrite 1).
  .x[, susceptible.1 := as.integer(perc_susc >= .cutoff)]
  return(.x[])
}
