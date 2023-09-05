
# test diversities table -------------------------------------------------------
data(P_sojae_survey)
Ps <-
  as.data.frame(P_sojae_survey)

test_that("input is a data frame and not a data.table", {
  expect_is(Ps, "data.frame")
  expect_failure(expect_is(Ps, "data.table"))
})

diversities <- calculate_diversities(
  x = Ps,
  cutoff = 60,
  control = "susceptible",
  sample = "Isolate",
  gene = "Rps",
  perc_susc = "perc.susc"
)

test_that("internal checker doesn't fail us", {
  expect_is(Ps, "data.frame")
  expect_failure(expect_is(Ps, "data.table"))
})

test_that("diversity_table() returns a pander object", {
  expect_type(capture.output(
    diversities_table(x = diversities, type = "text")), "character")
})

test_that("diversity_table() stops if object is not hagis.diversities object", {
  expect_error(diversities_table("y"),
               regexp = "This is not a hagis.diversities object.")
          })
