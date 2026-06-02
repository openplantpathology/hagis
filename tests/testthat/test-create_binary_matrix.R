data(P_sojae_survey)

final_matrix <- create_binary_matrix(
  x = P_sojae_survey,
  cutoff = 60,
  control = "susceptible",
  sample = "Isolate",
  gene = "Rps",
  perc_susc = "perc.susc"
)

# create_binary_matrix() ------------------------------------------------------

test_that("create_binary_matrix() returns a binary matrix with correct structure", {
  expect_true(is.matrix(final_matrix))
  expect_type(final_matrix, "double")
  expect_length(final_matrix, 273L)
  expect_identical(nrow(final_matrix), 21L)
  expect_identical(ncol(final_matrix), 13L)
  # dcast sorts sample names lexicographically as strings ("1","10","11",...),
  # not by order of appearance ("1","2","3",...); use expect_setequal() so the
  # assertion is order-independent
  expect_setequal(
    rownames(final_matrix),
    as.character(unique(P_sojae_survey$Isolate))
  )
  expect_identical(
    colnames(final_matrix),
    c(
      "Rps 1a",
      "Rps 1b",
      "Rps 1c",
      "Rps 1d",
      "Rps 1k",
      "Rps 2",
      "Rps 3a",
      "Rps 3b",
      "Rps 3c",
      "Rps 4",
      "Rps 5",
      "Rps 6",
      "Rps 7"
    )
  )
})

test_that("create_binary_matrix() returns only binary values", {
  expect_true(all(final_matrix %in% c(0, 1)))
})

test_that("create_binary_matrix() errors on invalid inputs", {
  expect_error(
    create_binary_matrix(
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
    create_binary_matrix(
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
    create_binary_matrix(
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
    create_binary_matrix(
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
    create_binary_matrix(
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
    create_binary_matrix(
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
