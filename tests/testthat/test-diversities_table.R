# test diversities_table() and individual_pathotypes() ------------------------

data(P_sojae_survey)

# Explicitly use a plain data.frame (not data.table) to verify that
# .check_inputs() handles non-data.table input correctly
Ps <- as.data.frame(P_sojae_survey)

test_that("test fixture is a plain data.frame and not a data.table", {
  expect_s3_class(Ps, "data.frame")
  expect_false(inherits(Ps, "data.table"))
})

diversities <- calculate_diversities(
  x = Ps,
  cutoff = 60,
  control = "susceptible",
  sample = "Isolate",
  gene = "Rps",
  perc_susc = "perc.susc"
)

test_that("calculate_diversities() accepts a plain data.frame as input", {
  expect_s3_class(diversities, "hagis.diversities")
})

# diversities_table() ---------------------------------------------------------

test_that("diversities_table() produces character output", {
  expect_type(
    utils::capture.output(diversities_table(x = diversities, type = "text")),
    "character"
  )
})

test_that("diversities_table() errors when input is not a hagis.diversities object", {
  expect_error(
    diversities_table("y"),
    regexp = "This is not a hagis.diversities object.",
    fixed = TRUE
  )
})

# individual_pathotypes() -----------------------------------------------------

test_that("individual_pathotypes() produces character output", {
  expect_type(
    utils::capture.output(individual_pathotypes(
      x = diversities,
      type = "text"
    )),
    "character"
  )
})

test_that("individual_pathotypes() errors when input is not a hagis.diversities object", {
  expect_error(
    individual_pathotypes("y"),
    regexp = "This is not a `hagis.diversities` object.",
    fixed = TRUE
  )
})
