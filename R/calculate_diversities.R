#' Calculate Diversities Indices
#'
#' @description Calculate five pathogen diversity indices.
#'
#' The calculations follow the original 'HaGiS' spreadsheet implementation
#' where possible. In particular, Simple, Gleason, Shannon and Simpson use the
#' total number of samples as the denominator, and each sample contributes one
#' pathotype to the frequency table. Samples with no susceptible reactions are
#' retained as an explicit empty pathotype class so that the frequency table
#' denominator matches the original Microsoft Excel/VBA implementation
#' implementation.
#'
#' Two edge-case behaviours are represented in an \R-native way: Evenness is
#' returned as `NA_real_` when there is only one pathotype, corresponding to the
#' original workbook leaving the value blank/not calculated. Simpson is returned
#' as 0 for one sample to match the original 'VBA' initialisation.
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
#'    diversity and 0 represents no diversity. Diversity is calculated using
#'    the finite-sample formula of Herrmann, Löwer, and Schachtel (1999):
#'    \deqn{ D = 1 - \frac{\sum (n_i^2 - n_i)}{N^2 - N} }{
#'      D = 1 - sum(n_i^2 - n_i) / (N^2 - N) }
#'    where \eqn{n_i} is the number of samples of pathotype \eqn{i} and
#'    #' where \eqn{N} is the total number of samples and \eqn{n_i} is the
#'    number of samples of pathotype \eqn{i}. Because samples with no
#'    susceptible reactions are retained as an empty pathotype class,
#'    \eqn{N = \sum n_i}.
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
#' diversities
#'
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
#' @references
#' Herrmann, A., Löwer, C. F., and Schachtel, G. A. (1999). A new tool
#' for entry and analysis of virulence data for plant pathogens.
#' \emph{Plant Pathology}, 48(2), 154-158.
#' \doi{10.1046/j.1365-3059.1999.00325.x}
#' @export

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

  all_samples <- data.table::data.table(
    Sample = sort(unique(dt_x[["sample"]]))
  )

  N_samples <- nrow(all_samples)

  if (N_samples == 0L) {
    stop(
      call. = FALSE,
      "No samples remain after removing the susceptible control."
    )
  }

  # create susceptible.1 binary column
  dt_x <- .binary_cutoff(.x = dt_x, .cutoff = cutoff)

  # retain only susceptible reactions for pathotype construction
  dt_susc <- dt_x[susceptible.1 != 0L]

  # Build per-sample pathotype strings.
  #
  # Important for tracking the original HaGiS VBA implementation:
  # every sample contributes one pathotype to the frequency table. Samples
  # with no susceptible reactions are retained as an explicit empty pathotype
  # class rather than being dropped.
  individual_pathotypes <- dt_susc[,
    list(Pathotype = toString(sort(gene))),
    by = list(Sample = sample)
  ]

  individual_pathotypes <- merge(
    all_samples,
    individual_pathotypes,
    by = "Sample",
    all.x = TRUE,
    sort = FALSE
  )

  individual_pathotypes[
    is.na(Pathotype),
    Pathotype := ""
  ]

  # Frequency table of pathotypes
  table_of_pathotypes <- individual_pathotypes[,
    list(Frequency = .N),
    by = Pathotype
  ]

  data.table::setcolorder(table_of_pathotypes, c("Frequency", "Pathotype"))
  data.table::setorder(table_of_pathotypes, -Frequency)

  # Number of unique pathotypes
  N_pathotypes <- nrow(table_of_pathotypes)

  # indices --------------------------------------------------------------------
  Simple <- N_pathotypes / N_samples

  # VBA returns 0 when there is exactly one isolate/sample.
  Gleason <- if (N_samples == 1L) {
    0.0
  } else {
    (N_pathotypes - 1L) / log(N_samples)
  }

  # VBA calculates p = n_i / n, where n is the total number of isolates/samples.
  prop <- table_of_pathotypes[["Frequency"]] / N_samples

  # Shannon index.
  # R's log() is the natural log, equivalent to the VBA Log() calculation.
  Shannon <- -sum(prop * log(prop), na.rm = TRUE)

  # Simpson diversity index using the finite-sample formula implemented in
  # the original HaGiS workbook and described by Herrmann, Löwer, and
  # Schachtel (1999).
  n_i <- table_of_pathotypes[["Frequency"]]

  # VBA initialises Simpson to 0 and only recalculates it when n > 1.
  Simpson <- if (N_samples > 1L) {
    1.0 - sum(n_i * (n_i - 1L)) / (N_samples * (N_samples - 1L))
  } else {
    0.0
  }

  # Evenness.
  # The VBA only writes this when r > 1. In R, NA is the clean equivalent of
  # the workbook's blank / not-calculated state.
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
  class(z) <- c("hagis.diversities", "list")
  return(z)
}

#' Prints hagis.diversities Object
#'
#' Custom [print()] method for `hagis.diversities` objects.
#'
#' @param x a `hagis.diversities` object
#' @param digits number of digits to print
#' @param ... ignored
#' @method print hagis.diversities
#' @export
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
#' Print the frequency table of diversities from a `hagis.diversities` object
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
#' # print the diversities table
#' diversities_table(diversities)
#'
#' @returns A [pander::pandoc.table()] object of diversities
#' @seealso [calculate_diversities()], [individual_pathotypes()]
#' @export
diversities_table <- function(x, ...) {
  if (class(x)[1L] != "hagis.diversities") {
    stop(
      call. = FALSE,
      "This is not a hagis.diversities object."
    )
  } else {
    pander::pander(x[[2L]], ...)
  }
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
  stop(
    call. = FALSE,
    "This is not a `hagis.diversities` object."
  )
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
      )
    )
  }
