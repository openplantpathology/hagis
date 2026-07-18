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
