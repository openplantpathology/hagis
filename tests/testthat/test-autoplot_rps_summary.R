
# test plot.hagis.gene.summary ----------------------------------------------

data(P_sojae_survey)
rps <- summarize_gene(
  x = P_sojae_survey,
  cutoff = 60,
  control = "susceptible",
  sample = "Isolate",
  gene = "Rps",
  perc_susc = "perc.susc"
)

test_that("autoplot.hagis.gene.summary() rtns a {ggplot2} object 4 count", {
            skip_on_cran()
            rps_count <- autoplot(rps, type = "count")
            vdiffr::expect_doppelganger("count_summary", rps_count)
          })

test_that("autoplot.hagis.gene.summary() rtns a {ggplot2} object 4 %", {
  skip_on_cran()
  rps_perc <- autoplot(rps, type = "percentage")
  vdiffr::expect_doppelganger("perc_summary", rps_perc)
})

test_that("autoplot.hagis.gene.summary() rtns a blue {ggplot2} object", {
  skip_on_cran()
  rps_perc_blue <-
    autoplot(rps, type = "percentage", color = "blue")
  vdiffr::expect_doppelganger("perc_summary_blue", rps_perc_blue)
})
test_that("autoplot.hagis.gene.summary() rtns a descending {ggplot2} object",
          {
            skip_on_cran()
            rps_perc_desc_blue <-
              autoplot(rps,
                       type = "percentage",
                       color = "blue",
                       order = "descending")
            vdiffr::expect_doppelganger("perc_summary_des_blue",
                                        rps_perc_desc_blue)
          })

test_that("autoplot.hagis.gene.summary() rtns ascending {ggplot2} object 4 %",
          {
            skip_on_cran()
            rps_perc_asc_blue <-
              autoplot(rps,
                       type = "percentage",
                       color = "blue",
                       order = "ascending")
            vdiffr::expect_doppelganger("perc_summary_asc_blue",
                                        rps_perc_asc_blue)
          })

test_that("autoplot.hagis.gene.summary() rtns sorted {ggplot2} object 4 cnt",
          {
            skip_on_cran()
            rps_count_asc_blue <-
              autoplot(rps,
                       type = "count",
                       color = "blue",
                       order = "ascending")
            vdiffr::expect_doppelganger("count_summary_asc_blue",
                                        rps_count_asc_blue)
          })

test_that("autoplot.hagis.gene.summary() errors on invalid type", {
  skip_on_cran()
  expect_error(autoplot(rps, type = "orange"),
               regexp = "You have entered an invalid `type`.")
})
