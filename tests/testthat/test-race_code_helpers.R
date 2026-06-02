# test race code helpers ------------------------------------------------------

test_that("decode_race_octal() round-trips encode_race_octal()", {
  x <- c(1, 1, 1, 0, 0, 1, 1)
  code <- encode_race_octal(x)
  expect_equal(decode_race_octal(code, n = length(x)), x)
})

test_that("decode_race_decanary() round-trips encode_race_decanary()", {
  x <- c(1, 0, 1, 1, 0, 0, 1)
  code <- encode_race_decanary(x)
  expect_equal(decode_race_decanary(code, n = length(x)), x)
})

test_that("decode_race_name() dispatches correctly", {
  x <- c(1, 0, 1, 0, 1, 0)

  expect_equal(
    decode_race_name(encode_race_octal(x), system = "octal", n = length(x)),
    x
  )

  expect_equal(
    decode_race_name(
      encode_race_decanary(x),
      system = "decanary",
      n = length(x)
    ),
    x
  )
})

test_that("decode_race_code_table() round-trips race_code_table() output", {
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

  codes <- race_code_table(x)

  expect_equal(decode_race_code_table(codes, system = "octal"), x)
  expect_equal(decode_race_code_table(codes, system = "decanary"), x)
})

test_that("print.hagis.race_codes() returns invisibly", {
  x <- matrix(c(1, 0, 1, 1, 0, 0), nrow = 1)
  rownames(x) <- "A"
  codes <- race_code_table(x)

  expect_identical(
    utils::capture.output(y <- print(codes)) |> is.character(),
    TRUE
  )
  expect_identical(y, codes)
})

test_that("pander.hagis.race_codes() returns invisibly", {
  skip_if_not_installed("pander")

  x <- matrix(c(1, 0, 1, 1, 0, 0), nrow = 1)
  rownames(x) <- "A"
  codes <- race_code_table(x)

  expect_type(utils::capture.output(pander::pander(codes)), "character")
})
