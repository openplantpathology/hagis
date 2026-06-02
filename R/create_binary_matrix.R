#' Create Binary Data Matrix From Pathotype Data
#'
#' @description Creates a binary data matrix from pathotype data representing
#'  the pathotype of each isolate.  This binary data matrix can be used to
#'  visualize beta-diversity of pathotypes using \CRANpkg{vegan} and
#'  \CRANpkg{ape}.
#'
#' @inheritParams summarize_gene
#' @autoglobal
#' @examplesIf interactive()
#'
#' # Using the built-in data set, `P_sojae_survey`
#' data(P_sojae_survey)
#'
#' P_sojae_survey
#'
#' # calculate susceptibilities with a 60 % cutoff value
#' final_matrix <- create_binary_matrix(
#'   x = P_sojae_survey,
#'   cutoff = 60,
#'   control = "susceptible",
#'   sample = "Isolate",
#'   gene = "Rps",
#'   perc_susc = "perc.susc"
#' )
#' final_matrix
#'
#' @returns a binary matrix of pathotype data
#'
#' @export create_binary_matrix
#'
create_binary_matrix <- function(x, cutoff, control, sample, gene, perc_susc) {
  # check inputs and rename columns to work with this package
  dt_x <- .check_inputs(
    .x = x,
    .cutoff = cutoff,
    .control = control,
    .sample = sample,
    .gene = gene,
    .perc_susc = perc_susc
  )

  dt_x <- dt_x[gene != control]

  # create susceptible.1 binary column
  dt_x <- .binary_cutoff(.x = dt_x, .cutoff = cutoff)

  # Select only the columns needed for the wide pivot
  dt_x <- dt_x[, list(sample, gene, susceptible.1)]

  wide <- dcast(
    dt_x,
    gene ~ sample,
    value.var = "susceptible.1",
    fun.aggregate = mean
  )

  # Transpose so rows = samples, cols = genes (standard beta-diversity input)
  x <- t(as.matrix(wide, rownames = "gene"))

  return(x)
}
