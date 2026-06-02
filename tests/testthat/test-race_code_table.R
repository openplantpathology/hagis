# test race_code_table() ------------------------------------------------------

test_that("race_code_table() returns correct structure", {
  x <- matrix(
    c(
      1,
      1,
      1,
      0,
      0,
      1,
      1,
      0,
      0,
      1,
      1,
      0
    ),
    nrow = 2,
    byrow = TRUE
  )
  rownames(x) <- c("A", "B")
  colnames(x) <- c("G1", "G2", "G3", "G4", "G5", "G6")

  out <- race_code_table(x)

  expect_s3_class(out, "hagis.race_codes")
  expect_named(
    out,
    c("sample", "pathotype_vector", "octal_code", "decanary_code", "complexity")
  )
  expect_equal(out$sample, c("A", "B"))
})

test_that("race_code_table() computes codes and complexity correctly", {
  x <- matrix(c(1, 1, 1, 0, 0, 1), nrow = 1)
  rownames(x) <- "A"

  out <- race_code_table(x)

  expect_equal(out$pathotype_vector, "111001")
  expect_equal(out$octal_code, "74")
  expect_equal(out$decanary_code, as.character(1 + 2 + 4 + 32))
  expect_equal(out$complexity, 4)
})

test_that("race_code_table() errors on invalid input", {
  expect_error(
    race_code_table(data.frame(a = 1:3)),
    regexp = "`x` must be a matrix.",
    fixed = TRUE
  )

  bad <- matrix(c(1, 2, 0, 1), nrow = 2)
  expect_error(
    race_code_table(bad),
    regexp = "`x` must be a binary matrix containing only 0 and 1.",
    fixed = TRUE
  )
})
