

# test diversities table -------------------------------------------------------
data(P_sojae_survey)
diversities <- calculate_diversities(
  x = P_sojae_survey,
  cutoff = 60,
  control = "susceptible",
  sample = "Isolate",
  gene = "Rps",
  perc_susc = "perc.susc"
)

test_that("individual_pathotypes() returns a pander object", {
  skip_on_cran()
  expect_type(
    capture.output(
      individual_pathotypes(x = diversities, type = "text")), "character")
})

test_that("individual_pathotypes() stops if object is not hagis.diversities
          object", {
            skip_on_cran()
            expect_error(individual_pathotypes("y"),
                         regexp = "This is not a hagis.diversities object.")
          })
