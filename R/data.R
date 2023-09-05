#' _Phytophthora sojae_ Survey Example Data
#'
#' Data from a _Phytophthora sojae_ survey
#'
#' @docType data
#'
#' @usage data(P_sojae_survey)
#'
#' @format An object of class `data.table` with 294 observations of 12 variables
#' \describe{
#'   \item{Isolate}{_P. sojae_ isolate identifier}
#'   \item{Line}{Soybean cultivar}
#'   \item{Rps}{_Rps_ gene identifier}
#'   \item{Total}{Total number of plants inoculated}
#'   \item{HR (1)}{Number of plants that exhibit a hypersensitive response after
#'    inoculation}
#'   \item{Lesion (2)}{Number of plants that develop a lesion at inoculation
#'    site}
#'   \item{Lesion to cotyledon (3)}{Number of plants that develop a lesion,
#'    which advances to the hypocotyl of the seedling after infection}
#'   \item{Dead (4)}{Number of dead plants that are observed after inoculation}
#'   \item{total.susc}{The total number of susceptible plants (Lesion+Lesion to
#'    cotyledon+Dead)}
#'   \item{total.resis}{The total number of resistant plants (equal to HR
#'    value)}
#'   }
#'
#' @keywords datasets
#'
#' @source Data from an ongoing 2017 _Phytophthora sojae_ survey in Michigan,
#' conducted by A. G. McCoy _et al._.
#'
#' @examplesIf interactive()
#' data(P_sojae_survey)
#' P_sojae_survey
#'
"P_sojae_survey"

#' _Phytophthora sojae_ Survey Example Metadata
#'
#' Metadata to accompany internal data from a _Phytophthora sojae_ survey used
#' for an example in the "Beta-diversity Analyses" vignette.
#'
#' @docType data
#'
#' @usage data(sample_meta)
#'
#' @format An object of class `data.frame` with 21 observations of 2 variables
#' \describe{
#'   \item{Sample}{_P. sojae_ sample identifier}
#'   \item{Locale}{US State where sample was collected, limited to Michigan}
#'   }
#'
#' @keywords datasets
#'
#' @source Data from an ongoing 2017 _Phytophthora sojae_ survey in Michigan,
#' conducted by A. G. McCoy _et al._.
#'
#' @examplesIf interactive()
#' data(sample_meta)
#' sample_meta
#'
"sample_meta"
