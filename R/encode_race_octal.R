#' Encode a binary pathotype vector as reverse binary/octal
#'
#' @param x Integer/numeric/logical vector of 0/1 values.
#' @returns A single character string containing the reverse octal race name.
#' @keywords internal
encode_race_octal <- function(x) {
  if (is.logical(x)) {
    x <- as.integer(x)
  }

  if (!is.numeric(x) || anyNA(x) || !all(x %in% c(0L, 1L))) {
    stop("`x` must be a binary vector containing only 0 and 1.", call. = FALSE)
  }

  n <- length(x)
  rem <- n %% 3L

  if (rem != 0L) {
    x <- c(x, rep.int(0, 3L - rem))
  }

  m <- matrix(x, ncol = 3L, byrow = TRUE)
  digits <- m[, 1] + 2L * m[, 2] + 4L * m[, 3]
  paste(digits, collapse = "")
}

#' Encode a binary pathotype vector as reverse binary/decanary
#'
#' @param x Integer/numeric/logical vector of 0/1 values.
#' @returns A single character string containing the reverse decanary race name.
#' @keywords internal
encode_race_decanary <- function(x) {
  if (is.logical(x)) {
    x <- as.integer(x)
  }

  if (!is.numeric(x) || anyNA(x) || !all(x %in% c(0L, 1L))) {
    stop("`x` must be a binary vector containing only 0 and 1.", call. = FALSE)
  }

  as.character(sum(x * (2^(seq_along(x) - 1L))))
}

#' Create a race code summary table from a binary matrix
#'
#' @description
#' Convert the output of `create_binary_matrix()` into a table containing sample
#' identifiers, pathotype vectors, reverse binary/octal race names, reverse
#' binary/decanary race names, and complexity.
#'
#' @param x A binary matrix produced by `create_binary_matrix()`, with samples
#'  in rows and genes/differentials in columns.
#'
#' @returns A [data.table::data.table] with one row per sample.
#' @export
race_code_table <- function(x) {
  if (!is.matrix(x)) {
    stop("`x` must be a matrix.", call. = FALSE)
  }

  if (!is.numeric(x) || anyNA(x) || !all(x %in% c(0L, 1L))) {
    stop("`x` must be a binary matrix containing only 0 and 1.", call. = FALSE)
  }

  sample_ids <- rownames(x)
  if (is.null(sample_ids)) {
    sample_ids <- as.character(seq_len(nrow(x)))
  }

  pathotype_vector <- apply(
    x,
    1,
    function(row) paste(row, collapse = "")
  )

  octal_code <- apply(x, 1, encode_race_octal)
  decanary_code <- apply(x, 1, encode_race_decanary)
  complexity <- rowSums(x)

  out <- data.table::data.table(
    sample = sample_ids,
    pathotype_vector = unname(pathotype_vector),
    octal_code = unname(octal_code),
    decanary_code = unname(decanary_code),
    complexity = unname(complexity)
  )

  class(out) <- union("hagis.race_codes", class(out))
  out
}
