#' Calculate Pairwise Race/Pathotype Similarity
#'
#' @description
#' Calculate pairwise similarity between binary pathotype vectors.
#'
#' @param x A binary matrix, usually produced by [create_binary_matrix()].
#'   Rows are samples/races and columns are genes/differentials.
#' @param method Similarity coefficient. `dice` calculates
#'   \eqn{2a / (2a + b + c)}, where \eqn{a} is shared 1/1 virulence,
#'   \eqn{b} is 1/0, and \eqn{c} is 0/1.
#'
#' @returns A symmetric numeric matrix of pairwise similarities.
#' @export
race_similarity_matrix <- function(
  x,
  method = c("dice", "jaccard", "simple_matching")
) {
  method <- match.arg(method)
  .validate_binary_matrix(x)

  n <- nrow(x)
  sample_ids <- rownames(x)
  if (is.null(sample_ids)) {
    sample_ids <- as.character(seq_len(n))
  }

  out <- matrix(
    NA_real_,
    nrow = n,
    ncol = n,
    dimnames = list(sample_ids, sample_ids)
  )

  for (i in seq_len(n)) {
    for (j in seq_len(n)) {
      a <- sum(x[i, ] == 1L & x[j, ] == 1L)
      b <- sum(x[i, ] == 1L & x[j, ] == 0L)
      c <- sum(x[i, ] == 0L & x[j, ] == 1L)
      d <- sum(x[i, ] == 0L & x[j, ] == 0L)

      out[i, j] <- switch(
        method,
        dice = if ((2L * a + b + c) == 0L) {
          NA_real_
        } else {
          (2L * a) / (2L * a + b + c)
        },
        jaccard = if ((a + b + c) == 0L) {
          NA_real_
        } else {
          a / (a + b + c)
        },
        simple_matching = (a + d) / (a + b + c + d)
      )
    }
  }

  return(out)
}

#' Calculate Pairwise Race/Pathotype Similarity Table
#'
#' @inheritParams race_similarity_matrix
#'
#' @returns A `data.table` with pairwise race similarities.
#' @export
race_similarity_table <- function(
  x,
  method = c("dice", "jaccard", "simple_matching")
) {
  method <- match.arg(method)
  mat <- race_similarity_matrix(x, method = method)

  out <- as.data.table(as.table(mat))
  data.table::setnames(out, c("sample_1", "sample_2", "similarity"))
  out[, method := method]
  return(out[])
}
