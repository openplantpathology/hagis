% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/summarize_gene.R
\name{summarize_gene}
\alias{summarize_gene}
\title{Calculate and Summarize Distribution of Susceptibilities by Gene}
\usage{
summarize_gene(x, cutoff, control, sample, gene, perc_susc)
}
\arguments{
\item{x}{a \code{data.frame} containing the data.}

\item{cutoff}{value for percent susceptible cutoff. \code{Numeric}.}

\item{control}{value used to denote the susceptible control in the \code{gene}
column. \code{Character}.}

\item{sample}{column providing the unique identification for each sample
being tested. \code{Character}.}

\item{gene}{column providing the gene(s) being tested. \code{Character}.}

\item{perc_susc}{column providing the percent susceptible reactions.
\code{Character}.}
}
\value{
a \code{hagis.gene.summary} object.

An object of class \code{hagis.gene.summary} is a\cr \code{\link[data.table:data.table]{data.table::data.table()}}
containing the following components columns
\describe{
\item{gene}{the gene}
\item{N_virulent_isolates}{the total number virulent isolates for a
given gene in the \code{gene} column}
\item{percent_pathogenic}{the frequency with which a gene is pathogenic}
}
}
\description{
Calculate the distribution of susceptibilities by gene.
}
\examples{
\dontshow{if (interactive()) withAutoprint(\{ # examplesIf}
# Using the built-in data set, `P_sojae_survey`
data(P_sojae_survey)

P_sojae_survey

# calculate susceptibilities with a 60 \% cutoff value
susc <- summarize_gene(
  x = P_sojae_survey,
  cutoff = 60,
  control = "susceptible",
  sample = "Isolate",
  gene = "Rps",
  perc_susc = "perc.susc"
)
susc
\dontshow{\}) # examplesIf}
}
