#' Calculate Pairwise Virulence Differences
#'
#' @description
#' Calculate pairwise differences between binary pathotype vectors.
#'
#' @param x A binary matrix, usually produced by [create_binary_matrix()].
#'   Rows are samples/races and columns are genes/differentials.
#'
#' @returns A symmetric integer matrix giving the number of different
#'   virulence reactions between each pair of samples.
#' @export
virulence_difference_matrix <- function(x) {
  .validate_binary_matrix(x)

  n <- nrow(x)
  sample_ids <- rownames(x)
  if (is.null(sample_ids)) {
    sample_ids <- as.character(seq_len(n))
  }

  out <- matrix(
    0L,
    nrow = n,
    ncol = n,
    dimnames = list(sample_ids, sample_ids)
  )

  for (i in seq_len(n)) {
    for (j in seq_len(n)) {
      out[i, j] <- sum(x[i, ] != x[j, ])
    }
  }

  return(out)
}

#' Calculate Pairwise Virulence-Difference Table
#'
#' @param x A binary matrix, usually produced by [create_binary_matrix()].
#'
#' @returns A `data.table` with one row per pairwise comparison.
#' @export
virulence_difference_table <- function(x) {
  .validate_binary_matrix(x)

  sample_ids <- rownames(x)
  if (is.null(sample_ids)) {
    sample_ids <- as.character(seq_len(nrow(x)))
  }

  pairs <- data.table::CJ(
    sample_1 = sample_ids,
    sample_2 = sample_ids,
    sorted = FALSE
  )

  row_index <- stats::setNames(seq_along(sample_ids), sample_ids)

  .compare_pair <- function(i, j, x, row_index) {
    a <- x[row_index[[i]], ]
    b <- x[row_index[[j]], ]

    list(
      n_different = sum(a != b),
      n_shared_virulent = sum(a == 1L & b == 1L),
      n_sample_1_only = sum(a == 1L & b == 0L),
      n_sample_2_only = sum(a == 0L & b == 1L)
    )
  }

  stats <- Map(
    .compare_pair,
    pairs$sample_1,
    pairs$sample_2,
    MoreArgs = list(
      x = x,
      row_index = row_index
    )
  )

  pairs[,
    c(
      "n_different",
      "n_shared_virulent",
      "n_sample_1_only",
      "n_sample_2_only"
    ) := transpose(stats)
  ]

  return(pairs[])
}

#' Shared Validator
#' @dev
.validate_binary_matrix <- function(x) {
  if (!is.matrix(x)) {
    stop("`x` must be a matrix.", call. = FALSE)
  }

  if (!is.numeric(x) && !is.logical(x)) {
    stop("`x` must be a numeric or logical binary matrix.", call. = FALSE)
  }

  if (anyNA(x) || !all(x %in% c(0, 1))) {
    stop("`x` must contain only 0 and 1 values.", call. = FALSE)
  }

  invisible(TRUE)
}
