
# test create_binary_matrix ----------------------------------------------------
data(P_sojae_survey)
final_matrix <- create_binary_matrix(
  x = P_sojae_survey,
  cutoff = 60,
  control = "susceptible",
  sample = "Isolate",
  gene = "Rps",
  perc_susc = "perc.susc"
)

test_that("create_binary_matrix() works properly", {
  expect_is(final_matrix, "matrix")
  expect_type(final_matrix, "double")
  expect_length(final_matrix, 273)
  expect_equal(
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
