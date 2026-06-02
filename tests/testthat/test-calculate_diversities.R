data(P_sojae_survey)

diversities <- calculate_diversities(
  x = P_sojae_survey,
  cutoff = 60,
  control = "susceptible",
  sample = "Isolate",
  gene = "Rps",
  perc_susc = "perc.susc"
)

# calculate_diversities() -----------------------------------------------------

test_that("calculate_diversities() returns correct structure", {
  expect_s3_class(diversities, "hagis.diversities")
  expect_length(diversities, 9L)
  expect_named(
    diversities,
    c(
      "individual_pathotypes",
      "table_of_pathotypes",
      "number_of_samples",
      "number_of_pathotypes",
      "Simple",
      "Gleason",
      "Shannon",
      "Simpson",
      "Evenness"
    )
  )
})

test_that("calculate_diversities() returns correct index values", {
  expect_identical(diversities$number_of_samples, 21L)
  expect_identical(diversities$number_of_pathotypes, 19L)
  expect_equal(diversities$Simple, 0.9047619, tolerance = 1e-3)
  expect_equal(diversities$Gleason, 5.912257, tolerance = 1e-3)
  expect_equal(diversities$Shannon, 2.912494, tolerance = 1e-3)
  expect_equal(diversities$Simpson, 0.9433107, tolerance = 1e-3)
  expect_equal(diversities$Evenness, 0.9891509, tolerance = 1e-3)
})

test_that("calculate_diversities() errors on invalid inputs", {
  expect_error(
    calculate_diversities(
      x = "y",
      cutoff = 60,
      control = "susceptible",
      sample = "Isolate",
      gene = "Rps",
      perc_susc = "perc.susc"
    ),
    regexp = "You have failed to provide all necessary inputs",
    fixed = TRUE
  )
  expect_error(
    calculate_diversities(
      x = P_sojae_survey,
      cutoff = "sixty",
      control = "susceptible",
      sample = "Isolate",
      gene = "Rps",
      perc_susc = "perc.susc"
    ),
    regexp = "You have failed to provide all necessary inputs",
    fixed = TRUE
  )
  expect_error(
    calculate_diversities(
      x = P_sojae_survey,
      cutoff = 60,
      control = NULL,
      sample = "Isolate",
      gene = "Rps",
      perc_susc = "perc.susc"
    ),
    regexp = "You have failed to provide all necessary inputs",
    fixed = TRUE
  )
  expect_error(
    calculate_diversities(
      x = P_sojae_survey,
      cutoff = 60,
      control = "susceptible",
      sample = NULL,
      gene = "Rps",
      perc_susc = "perc.susc"
    ),
    regexp = "You have failed to provide all necessary inputs",
    fixed = TRUE
  )
  expect_error(
    calculate_diversities(
      x = P_sojae_survey,
      cutoff = 60,
      control = "susceptible",
      sample = "Isolate",
      gene = NULL,
      perc_susc = "perc.susc"
    ),
    regexp = "You have failed to provide all necessary inputs",
    fixed = TRUE
  )
  expect_error(
    calculate_diversities(
      x = P_sojae_survey,
      cutoff = 60,
      control = "susceptible",
      sample = "Isolate",
      gene = "Rps",
      perc_susc = 60
    ),
    regexp = "You have failed to provide all necessary inputs",
    fixed = TRUE
  )
})

test_that("calculate_diversities() errors on invalid perc_susc values", {
  x_non_numeric <- as.data.frame(P_sojae_survey)
  x_non_numeric[["perc.susc"]] <- as.character(x_non_numeric[["perc.susc"]])
  expect_error(
    calculate_diversities(
      x = x_non_numeric,
      cutoff = 60,
      control = "susceptible",
      sample = "Isolate",
      gene = "Rps",
      perc_susc = "perc.susc"
    ),
    regexp = "Data in the column `perc_susc` must be numeric.",
    fixed = TRUE
  )

  # negative perc_susc value — numeric assignment is fine here, no cast needed
  x_negative <- as.data.frame(P_sojae_survey)
  x_negative[1, "perc.susc"] <- -1
  expect_error(
    calculate_diversities(
      x = x_negative,
      cutoff = 60,
      control = "susceptible",
      sample = "Isolate",
      gene = "Rps",
      perc_susc = "perc.susc"
    ),
    regexp = "Data in the column `perc_susc` must be non-negative.",
    fixed = TRUE
  )
})

# print.hagis.diversities() ---------------------------------------------------

test_that("print.hagis.diversities() produces correct output", {
  x <- utils::capture.output(print(diversities))
  expect_type(x, "character")
  expect_identical(x[[2]], "hagis Diversities")
  expect_identical(x[[4]], "Number of Samples 21")
  expect_identical(x[[5]], "Number of Pathotypes 19 ")
  expect_identical(x[[8]], "Simple   0.9047619 ")
  expect_identical(x[[9]], "Gleason  5.912257 ")
  expect_identical(x[[10]], "Shannon  2.912494 ")
  expect_identical(x[[11]], "Simpson  0.9433107 ")
  expect_identical(x[[12]], "Evenness  0.9891509 ")
  expect_identical(x[[13]], "")
})

# pander.hagis.diversities() --------------------------------------------------

test_that("pander.hagis.diversities() produces correct output", {
  x <- utils::capture.output(pander::pander(diversities))
  expect_type(x, "character")
  expect_identical(
    head(x),
    c(
      "",
      "-------------------------------------------------",
      " Simple   Gleason   Shannon   Simpson   Evenness ",
      "-------- --------- --------- --------- ----------",
      " 0.9048    5.912     2.912    0.9433     0.9892  ",
      "-------------------------------------------------"
    )
  )
})
