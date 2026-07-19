#' Calculate Raw-Score Pathogenicity Index by Gene
#'
#' @description
#' Calculate the Pathogenicity Index (PI) for each gene/differential using raw
#' assessment scores, following Herrmann et al. (1999):
#'
#' \deqn{PI_\delta = \sum a_{\delta j} / (MAX \cdot N)}
#'
#' where \eqn{a_{\delta j}} is the raw score for sample \eqn{j} on gene
#' \eqn{\delta}, \eqn{MAX} is the maximum possible score on the assessment
#' scale, and \eqn{N} is the number of samples.
#'
#' @param x A `data.frame`.
#' @param max_score A single positive numeric value giving the upper limit of
#'   the assessment scale.
#' @param control A character string identifying the control in `gene`.
#' @param sample A character string naming the sample identifier column.
#' @param gene A character string naming the gene/differential column.
#' @param perc_susc A character string naming the raw score column.
#'
#' @return A `data.table` with class `hagis.gene.pi`.
#' @family summarize_gene
#' @autoglobal
#' @export

summarize_gene_pi <- function(x, max_score, control, sample, gene, perc_susc) {
  x_dt <- hagis_data(
    x = x,
    control = control,
    sample = sample,
    gene = gene,
    perc_susc = perc_susc
  )

  if (
    !is.numeric(max_score) ||
      length(max_score) != 1L ||
      is.na(max_score) ||
      max_score <= 0L
  ) {
    stop("`max_score` must be a single positive numeric value.", call. = FALSE)
  }

  # Remove susceptible control before counting samples, matching the
  # ordering used by every other hagis analysis function.
  x_dt <- x_dt[gene != control]
  N_samples <- length(unique(x_dt[["sample"]]))

  y <- x_dt[,
    list(sum_scores = sum(perc_susc, na.rm = TRUE)),
    by = gene
  ]

  y[, pathogenicity_index := sum_scores / (max_score * N_samples)]
  y[, pathogenicity_index_percent := pathogenicity_index * 100.0]

  class(y) <- union("hagis.gene.pi", class(y))
  return(y[])
}
