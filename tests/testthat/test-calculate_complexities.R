data(P_sojae_survey)
rps <- summarize_gene(
  x = P_sojae_survey,
  cutoff = 60,
  control = "susceptible",
  sample = "Isolate",
  gene = "Rps",
  perc_susc = "perc.susc"
)
# type ------------------------------------------------------------------------
test_that("autoplot.hagis.gene.summary() returns a ggplot2 object for count", {
  expect_s3_class(autoplot(rps, type = "count"), "gg")
  vdiffr::expect_doppelganger(
    "count_summary",
    autoplot(rps, type = "count")
  )
})
test_that("autoplot.hagis.gene.summary() returns a ggplot2 object for percentage", {
  expect_s3_class(autoplot(rps, type = "percentage"), "gg")
  vdiffr::expect_doppelganger(
    "perc_summary",
    autoplot(rps, type = "percentage")
  )
})
test_that("autoplot.hagis.gene.summary() errors on invalid type", {
  expect_error(
    autoplot(rps, type = "orange"),
    regexp = "should be one of",
    fixed = TRUE
  )
})
# color -----------------------------------------------------------------------
test_that("autoplot.hagis.gene.summary() respects color argument for percentage", {
  vdiffr::expect_doppelganger(
    "perc_summary_blue",
    autoplot(rps, type = "percentage", color = "blue")
  )
})
# order -----------------------------------------------------------------------
test_that("autoplot.hagis.gene.summary() respects descending order for percentage", {
  vdiffr::expect_doppelganger(
    "perc_summary_desc_blue",
    autoplot(rps, type = "percentage", color = "blue", order = "descending")
  )
})
test_that("autoplot.hagis.gene.summary() respects ascending order for percentage", {
  vdiffr::expect_doppelganger(
    "perc_summary_asc_blue",
    autoplot(rps, type = "percentage", color = "blue", order = "ascending")
  )
})
test_that("autoplot.hagis.gene.summary() respects ascending order for count", {
  vdiffr::expect_doppelganger(
    "count_summary_asc_blue",
    autoplot(rps, type = "count", color = "blue", order = "ascending")
  )
})
