
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
#' final_matrix <- create_binary_matrix(x = P_sojae_survey,
#'                                     cutoff = 60,
#'                                     control = "susceptible",
#'                                     sample = "Isolate",
#'                                     gene = "Rps",
#'                                     perc_susc = "perc.susc")
#' final_matrix
#'
#' @return `create_binary_matrix` returns a binary matrix of pathotype data as
#' a [matrix] object
#' 
#' @export create_binary_matrix
#' 
create_binary_matrix <- function(x,
                                 cutoff,
                                 control,
                                 sample,
                                 gene,
                                 perc_susc) {

  # check inputs and rename columns to work with this package
  x <- .check_inputs(
    .x = x,
    .cutoff = cutoff,
    .control = control,
    .sample = sample,
    .gene = gene,
    .perc_susc = perc_susc
  )

  # summarise the reactions, create susceptible.1 column, see
  # internal_functions.R
  x <- .binary_cutoff(.x = x, .cutoff = cutoff)
  
  # remove susceptible so Beta diversity is only calculated based on pathotype
  x <- subset(x, gene != control)
  
  x <- data.table(x[, c("sample", "gene", "susceptible.1")])
         
  x <-
    t(as.matrix(dcast(melt(x, id.vars = c("sample", "gene")),
                    gene  ~ sample, value.var = "value"),
              rownames = "gene"))
  
  return(x)
}
