#' Decode a reverse binary/octal race name to a binary pathotype vector
#'
#' @param code A single character string of octal digits 0-7.
#' @param n Optional integer length of the original pathotype vector. If
#'   supplied, trailing padded zeros are removed by truncating to `n`.
#'
#' @returns An integer vector of 0/1 values.
#' @dev
decode_race_octal <- function(code, n = NULL) {
  .validate_code_string(code)

  digits <- .octal_string_to_digits(code)
  out <- .decode_octal_digits(digits)

  if (is.null(n)) {
    return(out)
  }

  .validate_truncation_length(n)
  out[seq_len(n)]
}

#' Split an Octal Code String into Validated Integer Digits
#'
#' @param code a single character string of octal digits 0-7
#' @returns an integer vector of octal digits
#' @dev
.octal_string_to_digits <- function(code) {
  digits <- strsplit(code, "", fixed = TRUE)[[1]]

  if (!all(digits %in% as.character(0L:7L))) {
    stop("`code` must contain only octal digits 0-7.", call. = FALSE)
  }

  as.integer(digits)
}

#' Decode a Vector of Octal Digits to Binary Bits
#'
#' @param digits an integer vector of octal digits (0-7)
#' @returns an integer vector of 0/1 values, 3 bits per digit
#' @dev
.decode_octal_digits <- function(digits) {
  unlist(
    lapply(digits, .decode_one_octal_digit),
    use.names = FALSE
  )
}

#' Decode a Single Octal Digit to its Three Binary Bits
#'
#' @param d a single octal digit (0-7)
#' @returns an integer vector of length 3 (0/1 values)
#' @dev
.decode_one_octal_digit <- function(d) {
  c(
    d %% 2L,
    (d %/% 2L) %% 2L,
    (d %/% 4L) %% 2L
  )
}

#' Decode a reverse binary/decanary race name to a binary pathotype vector
#'
#' @param code A single character string representing a non-negative integer.
#' @param n Optional integer length of the original pathotype vector. If not
#'   provided, decoding continues until the value is exhausted.
#'
#' @returns An integer vector of 0/1 values.
#' @dev
decode_race_decanary <- function(code, n = NULL) {
  .validate_code_string(code)
  value <- .decanary_string_to_value(code)

  if (is.null(n)) {
    return(.decanary_to_bits_unbounded(value))
  }

  .validate_truncation_length(n)
  .decanary_to_bits_fixed(value, as.integer(n))
}

#' Parse and Validate a Decanary Code String's Numeric Value
#'
#' @param code a single character string representing a non-negative integer
#' @returns a single integer value
#' @dev
.decanary_string_to_value <- function(code) {
  value <- suppressWarnings(as.numeric(code))

  checks <- c(
    !is.na(value),
    value >= 0L,
    value == floor(value)
  )

  if (!all(checks)) {
    stop(
      "`code` must be a character representation of a non-negative integer.",
      call. = FALSE
    )
  }

  as.integer(value)
}

#' Decode a Decanary Value to Bits, Stopping Once the Value is Exhausted
#'
#' @param value a single non-negative integer
#' @returns an integer vector of 0/1 values
#' @dev
.decanary_to_bits_unbounded <- function(value) {
  if (value == 0L) {
    return(0L)
  }

  out <- integer()
  while (value > 0L) {
    out <- c(out, value %% 2L)
    value <- value %/% 2L
  }
  out
}

#' Decode a Decanary Value to a Fixed Number of Bits
#'
#' @param value a single non-negative integer
#' @param n the number of bits to return
#' @returns an integer vector of `n` 0/1 values
#' @dev
.decanary_to_bits_fixed <- function(value, n) {
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
#' @returns An integer vector of 0/1 values.
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
#' @returns A binary matrix with one row per sample.
#' @export
decode_race_code_table <- function(x, system = c("octal", "decanary")) {
  system <- match.arg(system)

  if (!inherits(x, "hagis.race_codes")) {
    stop("`x` must be a `hagis.race_codes` object.", call. = FALSE)
  }

  n <- nchar(x$pathotype_vector[[1]])
  samples <- x$sample

  if (system == "decanary") {
    values <- suppressWarnings(as.numeric(x$decanary_code))

    if (anyNA(values) || any(values < 0L) || any(values != floor(values))) {
      stop(
        "`decanary_code` must contain character representations of ",
        "non-negative integers.",
        call. = FALSE
      )
    }

    out <- vapply(
      seq_len(n) - 1L,
      function(bit) as.integer((values %/% (2L^bit)) %% 2L),
      integer(length(values))
    )
  } else {
    # Split every code into its digits in one vectorized pass, then
    # decode digit-by-digit (bounded by the number of gene-blocks)
    # instead of decoding one full code per sample via lapply().
    codes <- x$octal_code
    digit_chars <- do.call(rbind, strsplit(codes, "", fixed = TRUE))

    if (!all(digit_chars %in% as.character(0L:7L))) {
      stop("`octal_code` must contain only octal digits 0-7.", call. = FALSE)
    }

    digits <- matrix(
      as.integer(digit_chars),
      nrow = nrow(digit_chars),
      ncol = ncol(digit_chars)
    )

    bit_blocks <- lapply(seq_len(ncol(digits)), function(j) {
      d <- digits[, j]
      cbind(d %% 2L, (d %/% 2L) %% 2L, (d %/% 4L) %% 2L)
    })

    out <- do.call(cbind, bit_blocks)[, seq_len(n), drop = FALSE]
  }

  rownames(out) <- samples
  storage.mode(out) <- "integer"
  out
}

#' @autoglobal
#' @export
print.hagis.race_codes <- function(x, ...) {
  cat("\n")
  cat("hagis Race Codes\n")
  cat("\n")
  print.data.frame(
    as.data.frame(x[, list(
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

#' @autoglobal
#' @export
pander.hagis.race_codes <- function(x, caption = "hagis race codes", ...) {
  pander::pander(
    as.data.frame(x[, list(
      sample,
      pathotype_vector,
      octal_code,
      decanary_code,
      complexity
    )]),
    caption = caption,
    ...
  )
  invisible(x)
}
