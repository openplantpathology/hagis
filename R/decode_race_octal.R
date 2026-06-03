#' Decode a reverse binary/octal race name to a binary pathotype vector
#'
#' @param code A single character string of octal digits 0-7.
#' @param n Optional integer length of the original pathotype vector. If
#'   supplied, trailing padded zeros are removed by truncating to `n`.
#'
#' @return An integer vector of 0/1 values.
#' @keywords internal
decode_race_octal <- function(code, n = NULL) {
  if (!is.character(code) || length(code) != 1L || is.na(code)) {
    stop("`code` must be a single character string.", call. = FALSE)
  }

  digits <- strsplit(code, "", fixed = TRUE)[[1]]

  if (!all(digits %in% as.character(0:7))) {
    stop("`code` must contain only octal digits 0-7.", call. = FALSE)
  }

  digits <- as.integer(digits)

  out <- unlist(
    lapply(digits, function(d) {
      c(
        d %% 2L,
        (d %/% 2L) %% 2L,
        (d %/% 4L) %% 2L
      )
    }),
    use.names = FALSE
  )

  if (!is.null(n)) {
    if (!is.numeric(n) || length(n) != 1L || is.na(n) || n < 1) {
      stop("`n` must be a single positive integer.", call. = FALSE)
    }
    out <- out[seq_len(n)]
  }

  out
}

#' Decode a reverse binary/decanary race name to a binary pathotype vector
#'
#' @param code A single character string representing a non-negative integer.
#' @param n Optional integer length of the original pathotype vector. If not
#'   provided, decoding continues until the value is exhausted.
#'
#' @return An integer vector of 0/1 values.
#' @keywords internal
decode_race_decanary <- function(code, n = NULL) {
  if (!is.character(code) || length(code) != 1L || is.na(code)) {
    stop("`code` must be a single character string.", call. = FALSE)
  }

  value <- suppressWarnings(as.numeric(code))

  if (is.na(value) || value < 0 || value != floor(value)) {
    stop(
      "`code` must be a character representation of a non-negative integer.",
      call. = FALSE
    )
  }

  value <- as.integer(value)

  if (is.null(n)) {
    if (value == 0L) {
      return(0L)
    }

    out <- integer()
    while (value > 0L) {
      out <- c(out, value %% 2L)
      value <- value %/% 2L
    }
    return(out)
  }

  if (!is.numeric(n) || length(n) != 1L || is.na(n) || n < 1) {
    stop("`n` must be a single positive integer.", call. = FALSE)
  }

  n <- as.integer(n)
  out <- integer(n)

  for (i in seq_len(n)) {
    out[[i]] <- value %% 2L
    value <- value %/% 2L
  }

  out
}

#' Decode a race code to a pathotype vector
#'
#' @param code A single race code.
#' @param system One of `"octal"` or `"decanary"`.
#' @param n Optional integer length of the original pathotype vector.
#'
#' @return An integer vector of 0/1 values.
#' @export
decode_race_name <- function(code, system = c("octal", "decanary"), n = NULL) {
  system <- match.arg(system)

  if (system == "octal") {
    decode_race_octal(code, n = n)
  } else {
    decode_race_decanary(code, n = n)
  }
}

#' Decode a race code table back to a binary matrix
#'
#' @param x A `hagis.race_codes` object.
#' @param system One of `"octal"` or `"decanary"`.
#'
#' @return A binary matrix with one row per sample.
#' @export
decode_race_code_table <- function(x, system = c("octal", "decanary")) {
  system <- match.arg(system)

  if (!inherits(x, "hagis.race_codes")) {
    stop("`x` must be a `hagis.race_codes` object.", call. = FALSE)
  }

  n <- nchar(x$pathotype_vector[[1]])
  samples <- x$sample

  decoded <- lapply(seq_len(nrow(x)), function(i) {
    code <- if (system == "octal") x$octal_code[[i]] else x$decanary_code[[i]]
    decode_race_name(code, system = system, n = n)
  })

  out <- do.call(rbind, decoded)
  rownames(out) <- samples
  colnames(out) <- paste0("V", seq_len(ncol(out)))
  storage.mode(out) <- "integer"
  out
}

#' @export
print.hagis.race_codes <- function(x, ...) {
  cat("\n")
  cat("hagis Race Codes\n")
  cat("\n")
  print.data.frame(
    as.data.frame(x[, .(
      sample,
      pathotype_vector,
      octal_code,
      decanary_code,
      complexity
    )]),
    row.names = FALSE,
    ...
  )
  invisible(x)
}

#' @export
pander.hagis.race_codes <- function(x, caption = "hagis race codes", ...) {
  pander::pander(
    x[, .(
      sample,
      pathotype_vector,
      octal_code,
      decanary_code,
      complexity
    )],
    caption = caption,
    ...
  )
  invisible(x)
}
