
# test plot.hagis.complexities.summary -----------------------------------------
data(P_sojae_survey)
complexities <- calculate_complexities(
  x = P_sojae_survey,
  cutoff = 60,
  control = "susceptible",
  sample = "Isolate",
  gene = "Rps",
  perc_susc = "perc.susc"
)

test_that("auto.plot.hagis.complexities() returns a ggplot2 object 4 cnt", {
  complexities_count <- autoplot(complexities, type = "count")
  vdiffr::expect_doppelganger("count_complexities",
                      complexities_count)
})

test_that("auto.plot.hagis.complexities() returns a ggplot2 object 4 %", {
  complexities_perc <- autoplot(complexities, type = "percentage")
  vdiffr::expect_doppelganger("perc_complexities",
                      complexities_perc)
})

test_that("auto.plot.hagis.complexities() rtns a blue ggplot2 object 4 %", {
  complexities_perc_blue <-
    autoplot(complexities, type = "percentage",
             color = "blue")
  vdiffr::expect_doppelganger("perc_complexities_blue",
                      complexities_perc_blue)
})

test_that("auto.plot.hagis.complexities() rtns descending ggplot2 object 4 %", {
  complexities_perc_desc_blue <-
    autoplot(complexities,
             type = "percentage",
             color = "blue",
             order = "descending")
  vdiffr::expect_doppelganger("perc_complexities_desc_blue",
                      complexities_perc_desc_blue)
})

test_that("auto.plot.hagis.complexities() rtns ascending ggplot2 object 4 %", {
  complexities_perc_asc_blue <-
    autoplot(complexities,
             type = "percentage",
             color = "blue",
             order = "ascending")
  vdiffr::expect_doppelganger("perc_complexities_asc_blue",
                      complexities_perc_asc_blue)
})

test_that("auto.plot.hagis.complexities() rtns ascend ggplot2 object 4 cnt", {
  complexities_count_asc_blue <-
    autoplot(complexities,
             type = "count",
             color = "blue",
             order = "ascending")
  vdiffr::expect_doppelganger("count_complexities_asc_blue",
                      complexities_count_asc_blue)
})

test_that("auto.plot.hagis.complexities() errors on invalid type", {
  expect_error(autoplot(complexities, type = "orange"),
               regexp = "You have entered an invalid `type`.")
})
