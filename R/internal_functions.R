#' Check User Inputs
#'
#' Checks and validates user inputs before running functions
#'
#' @param .x a `data.table` containing the values to be summarised
#' @param .cutoff value for percent susceptible cutoff. Numeric.
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
  function(.x, .cutoff, .control, .sample, .gene, .perc_susc) {
    if (
      !is.data.frame(.x) ||
        !is.numeric(.cutoff) ||
        !is.character(.control) ||
        !is.character(.sample) ||
        !is.character(.gene) ||
        !is.character(.perc_susc)
    ) {
      stop(
        call. = FALSE,
        "You have failed to provide all necessary inputs or\n",
        "you have provided an improperly formatted item.\n",
        "Please check and try again."
      )
    }

    dt_x <- if (is.data.table(.x)) copy(.x) else as.data.table(.x)

    setnames(
      dt_x,
      c(.perc_susc, .gene, .sample),
      c("perc_susc", "gene", "sample")
    )

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

    # set col types for the necessary cols
    dt_x[, sample := as.character(sample)]
    dt_x[, gene := as.character(gene)]
    return(dt_x[])
  }

#' Create Binary Reaction Value
#'
#' Adds a column of 1 or 0 for the susceptible reaction cutoff
#'
#' @param .x A `data.table` containing the values to be summarised
#' @param .cutoff Cutoff value for susceptibility
#' @returns A `data.table` that tallies the results by gene
#' @keywords internal
#' @autoglobal
#' @noRd
.binary_cutoff <- function(.x, .cutoff) {
  perc_susc <- susceptible.1 <- NULL
  # Single-pass vectorised assignment: TRUE/FALSE coerced to 1/0.
  # Replaces the previous two-pass approach (init to 0, then overwrite 1).
  .x[, susceptible.1 := as.integer(perc_susc >= .cutoff)]
  return(.x[])
}
