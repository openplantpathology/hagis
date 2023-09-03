
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
#' @keywords internal
#' @autoglobal
#' @noRd
.check_inputs <-
  function(.x,
           .cutoff,
           .control,
           .sample,
           .gene,
           .perc_susc) {
    
    if (!is.data.frame(.x) |
        !is.numeric(.cutoff) |
        !is.character(.control) |
        !is.character(.sample) |
        !is.character(.gene) |
        !is.character(.perc_susc)) {
      stop(
        call. = FALSE,
        "You have failed to provide all necessary inputs or\n",
        "you have provided an improperly formatted item.\n",
        "Please check and try again."
      )
    }
    dt <- as.data.table(.x)
    setnames(dt,
             c(.perc_susc, .gene, .sample),
             c("perc_susc", "gene", "sample"))

    # validate that perc_susc is numeric
    if (!is.numeric(dt$perc_susc))
      stop("Data in the column `perc_susc` must be numeric.")
    # validate that no values in perc_susc < 0
    if (any(dt$perc_susc < 0, na.rm = TRUE))
      stop("Data in the column `perc_susc` must be non-negative.")

    # set col types for the necessary cols
    dt[, sample := as.character(sample)]
    dt[, gene := as.character(gene)]
    return(dt[])
  }

#' Create Binary Reaction Value
#'
#' Adds a column of 1 or 0 for the susceptible reaction cutoff
#'
#' @param .x A `data.table` containing the values to be summarised
#' @param .cutoff Cutoff value for susceptibility
#' @return A `data.table` that tallies the results by gene
#' @keywords internal
#' @autoglobal
#' @noRd
.binary_cutoff <- function(.x, .cutoff) {
  susceptible.1 <- perc_susc <- NULL
  # if else for resistant or susceptible reaction. This will mark susceptible
  # reactions with a "1" in a new column labelled "Susceptible.1" to then be
  # used in later analysis.
  .x[, susceptible.1 := 0]
  .x[perc_susc >= .cutoff, susceptible.1 := 1]
  return(.x[])
}
