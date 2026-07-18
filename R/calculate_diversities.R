#' Calculate Diversities Indices
#'
#' @description Calculate five pathogen diversity indices.
#'
#' Diversity indices include:
#'
#' * Simple diversity index, which will show the proportion of unique
#'   pathotypes to total samples. As the values gets closer to 1, there is
#'   greater diversity in pathoypes within the population. Simple diversity is
#'   calculated as:
#'   \deqn{ D = \frac{Np}{Ns} }{ D = Np / Ns }
#'    where \eqn{Np} is the number of pathotypes and \eqn{Ns} is the number of
#'    samples.
#'
#' * Gleason diversity index, an alternate version of Simple diversity index,
#'    is less sensitive to sample size than the Simple index.
#'    \deqn{ D = \frac{ (Np - 1) }{ log(Ns)}}{ D = (Np -1) / log(Ns) }
#'    Where \eqn{Np} is the number of pathotypes and \eqn{Ns} is the number of
#'    samples.
#'
#' * Shannon diversity index is typically between 1.5 and 3.5, as richness and
#'   evenness of the population increase, so does the Shannon index value.
#'   \deqn{ D = -\sum_{i = 1}^{R} p_i \log p_i }{ D = -sum p_i log(p_i) } Where
#'   \eqn{p_i} is the proportional abundance of species \eqn{i}.
#'
#' * Simpson diversity index values range from 0 to 1, 1 represents high
#'    diversity and 0 represents no diversity. Where diversity is calculated as:
#'    \deqn{ D = \sum_{i = 1}^{R} p_i^2 }{ D = sum p_i^2 }
#'
#' * Evenness ranges from 0 to 1, as the Evenness value approaches 1, there is
#'    a more even distribution of each pathoype's frequency within the
#'    population. Where Evenness is calculated as:
#'    \deqn{ D = \frac{H'}{log(Np) }}{ D = H' / log(Np) }
#'    where \eqn{H'} is the Shannon diversity index and \eqn{Np} is the number
#'    of pathotypes.
#'
#' @inheritParams summarize_gene
#' @autoglobal
#' @examplesIf interactive()
#' # Using the built-in data set, P_sojae_survey
#' data(P_sojae_survey)
#'
#' P_sojae_survey
#'
#' # calculate susceptibilities with a 60% cutoff value
#' diversities <- calculate_diversities(
#'   x = P_sojae_survey,
#'   cutoff = 60,
#'   control = "susceptible",
#'   sample = "Isolate",
#'   gene = "Rps",
#'   perc_susc = "perc.susc"
#' )
#'
#' diversities
#'
#' @export calculate_diversities
#' @returns A `hagis.diversities` object.
#'
#' A `hagis.diversities` object is a `list` containing:
#'   * Number of Samples
#'   * Number of Pathotypes
#'   * Simple Diversity Index
#'   * Gleason Diversity Index
#'   * Shannon Diversity Index
#'   * Simpson Diversity Index
#'   * Evenness Diversity Index
#'

calculate_diversities <- function(x, cutoff, control, sample, gene, perc_susc) {
  .validate_cutoff(cutoff)

  # check inputs and rename columns to work with this package
  dt_x <- hagis_data(
    x = x,
    control = control,
    sample = sample,
    gene = gene,
    perc_susc = perc_susc
  )

  # Remove susceptible control so it does not affect diversity calculations
  dt_x <- dt_x[gene != control]

  N_samples <- length(unique(dt_x[["sample"]]))

  # create susceptible.1 binary column
  dt_x <- .binary_cutoff(.x = dt_x, .cutoff = cutoff)

  # retain only susceptible reactions (pathotype)
  dt_susc <- dt_x[susceptible.1 != 0L]

  # Build per-sample pathotype strings in a single data.table grouping
  # (replaces split() + vapply() + toString())
  individual_pathotypes <- dt_susc[,
    list(Pathotype = toString(sort(gene))),
    by = list(Sample = sample)
  ]

  # Frequency table of pathotypes
  table_of_pathotypes <- individual_pathotypes[,
    list(Frequency = .N),
    by = Pathotype
  ]
  setcolorder(table_of_pathotypes, c("Frequency", "Pathotype"))
  setorder(table_of_pathotypes, -Frequency)

  # Number of unique pathotypes
  N_pathotypes <- nrow(table_of_pathotypes)

  # indices --------------------------------------------------------------------
  Simple <- N_pathotypes / N_samples
  Gleason <- (N_pathotypes - 1L) / log(N_samples)

  # Proportional abundances (renamed from `x` to avoid clobbering input)
  prop <- table_of_pathotypes[["Frequency"]] /
    sum(table_of_pathotypes[["Frequency"]])

  # Shannon index — natural log; log() with no base defaults to natural log
  Shannon <- -sum(prop * log(prop), na.rm = TRUE)

  # Simpson diversity index
  Simpson <- 1 - sum(prop * prop, na.rm = TRUE)

  # Evenness
  # log(N_pathotypes) is 0 when there is only a single pathotype, which
  # would otherwise silently produce 0/0 = NaN. Evenness is undefined in
  # that case, so we return NA instead.
  Evenness <- if (N_pathotypes > 1L) {
    Shannon / log(N_pathotypes)
  } else {
    NA_real_
  }

  z <- list(
    individual_pathotypes = individual_pathotypes,
    table_of_pathotypes = table_of_pathotypes,
    number_of_samples = N_samples,
    number_of_pathotypes = N_pathotypes,
    Simple = Simple,
    Gleason = Gleason,
    Shannon = Shannon,
    Simpson = Simpson,
    Evenness = Evenness
  )

  class(z) <- union("hagis.diversities", class(z))
  return(z)
}

#' Prints hagis.diversities Object
#'
#' Custom [print()] method for `hagis.diversities` objects.
#'
#' @param x a `hagis.diversities` object
#' @param ... ignored
#' @export
#' @noRd
print.hagis.diversities <- function(
  x,
  digits = max(3L, getOption("digits") - 3L),
  ...
) {
  cat("\nhagis Diversities\n")
  cat("\nNumber of Samples", x[[3L]])
  cat("\nNumber of Pathotypes", x[[4L]], "\n")
  cat("\n")
  cat("Indices\n")
  cat("Simple  ", x[[5L]], "\n")
  cat("Gleason ", x[[6L]], "\n")
  cat("Shannon ", x[[7L]], "\n")
  cat("Simpson ", x[[8L]], "\n")
  cat("Evenness ", x[[9L]], "\n")
  cat("\n")
  invisible(x)
}

#' Custom Print for hagis Diversities Tables
#'
#' Print the frequency table of diversities from a `hagis.diversities` object.
#' The resulting object is a \CRANpkg{pander} table (a text object for Markdown)
#' for ease of use in reporting and viewing in the console.
#'
#' @param x a `hagis.diversities` object generated by [calculate_diversities()]
#' @param ... other arguments passed to [pander::panderOptions()]
#'
#' @examplesIf interactive()
#' # Using the built-in data set, P_sojae_survey
#' data(P_sojae_survey)
#'
#' P_sojae_survey
#'
#' # calculate susceptibilities with a 60 % cutoff value
#' diversities <- calculate_diversities(
#'   x = P_sojae_survey,
#'   cutoff = 60,
#'   control = "susceptible",
#'   sample = "Isolate",
#'   gene = "Rps",
#'   perc_susc = "perc.susc"
#' )
#'
#' # print the diversities table
#' diversities_table(diversities)
#'
#' @returns A [pander::pandoc.table()] object of diversities
#' @seealso [calculate_diversities()], [individual_pathotypes()]
#' @export
diversities_table <- function(x, ...) {
  # BUG FIX: use inherits() for robustness, consistent with individual_pathotypes()
  if (!inherits(x, "hagis.diversities")) {
    stop(call. = FALSE, "This is not a hagis.diversities object.")
  }
  pander::pander(x[[2L]], ...)
}

#' Prints Individual Pathotypes for Each Sample
#'
#' Print an object from a `hagis.diversities` object with individual pathotypes,
#' _i.e._ each sample's pathotype. The resulting object is a \CRANpkg{pander}
#' table (a text object for Markdown) for ease of use in reporting and viewing
#' in the console.
#'
#' @inheritParams diversities_table
#' @examplesIf interactive()
#' # Using the built-in data set, P_sojae_survey
#' data(P_sojae_survey)
#'
#' P_sojae_survey
#'
#' # calculate susceptibilities with a 60 % cutoff value
#' diversities <- calculate_diversities(
#'   x = P_sojae_survey,
#'   cutoff = 60,
#'   control = "susceptible",
#'   sample = "Isolate",
#'   gene = "Rps",
#'   perc_susc = "perc.susc"
#' )
#'
#' # print the diversities table
#' individual_pathotypes(diversities)
#'
#' @returns A [pander::pander()] object of individual pathotypes
#' @seealso [calculate_diversities()], [diversities_table()]
#' @export
individual_pathotypes <- function(x, ...) {
  if (inherits(x, "hagis.diversities")) {
    return(pander::pander(x[[1L]], ...))
  }
  stop(call. = FALSE, "This is not a `hagis.diversities` object.")
}

#' Pander Method for {hagis} Diversities
#'
#' Prints a \CRANpkg{hagis} diversities in Pandoc's markdown.
#' @param x a diversities object
#' @param caption caption (string) to be shown under the table
#' @param ... optional parameters passed to raw `pandoc.table` function
#' @importFrom pander pander
#' @export
#' @noRd
pander.hagis.diversities <-
  function(x, caption = attr(x, "caption"), ...) {
    pander::pander(
      data.frame(
        Simple = x$Simple,
        Gleason = x$Gleason,
        Shannon = x$Shannon,
        Simpson = x$Simpson,
        Evenness = x$Evenness
      ),
      caption = sprintf(
        "Diversity indices where n = %d with %d pathotypes",
        x$number_of_samples,
        x$number_of_pathotypes
      ),
      ...
    )
  }
