
# test calculate complexities --------------------------------------------------
data(P_sojae_survey)
complexities <- calculate_complexities(
  x = P_sojae_survey,
  cutoff = 60,
  control = "susceptible",
  sample = "Isolate",
  gene = "Rps",
  perc_susc = "perc.susc"
)

test_that("calculate_complexities() works properly", {
  skip_on_cran()
  expect_s3_class(complexities, "hagis.complexities")
  expect_length(complexities, 2)
  expect_named(complexities,
               c("grouped_complexities",
                 "indvidual_complexities"))

  # test summary.hagis.complexities
  expect_length(summary(complexities), 3)
  expect_equal(summary(complexities)[[1]], 8.714286,
               tolerance = 1e-3)
  expect_equal(summary(complexities)[[2]], 2.003568,
               tolerance = 1e-3)
  expect_equal(summary(complexities)[[3]], 0.4372144,
               tolerance = 1e-3)
  expect_named(summary(complexities), c("mean", "sd", "se"))
})

test_that("calculate_complexities() stops if lacking all params", {
  skip_on_cran()
  expect_error(
    calculate_complexities(
      x = "y",
      cutoff = 60,
      control = "susceptible",
      sample = "Isolate",
      gene = "Rps",
      perc_susc = "perc.susc"
    ),
    regexp = "You have failed to provide all necessary inputs"
  )
  expect_error(
    calculate_complexities(
      x = P_sojae_survey,
      cutoff = "sixty",
      control = "susceptible",
      sample = "Isolate",
      gene = "Rps",
      perc_susc = "perc.susc"
    ),
    regexp = "You have failed to provide all necessary inputs"
  )
  expect_error(
    calculate_complexities(
      x = P_sojae_survey,
      cutoff = 60,
      control = NULL,
      sample = "Isolate",
      gene = "Rps",
      perc_susc = "perc.susc"
    ),
    regexp = "You have failed to provide all necessary inputs"
  )
  expect_error(
    calculate_complexities(
      x = P_sojae_survey,
      cutoff = 60,
      control = "susceptible",
      sample = NULL,
      gene = "Rps",
      perc_susc = "perc.susc"
    ),
    regexp = "You have failed to provide all necessary inputs"
  )
  expect_error(
    calculate_complexities(
      x = P_sojae_survey,
      cutoff = 60,
      control = "susceptible",
      sample = "isolate",
      gene = NULL,
      perc_susc = "perc.susc"
    ),
    regexp = "You have failed to provide all necessary inputs"
  )
  expect_error(
    calculate_complexities(
      x = P_sojae_survey,
      cutoff = 60,
      control = "susceptible",
      sample = "isolate",
      gene = "Rps",
      perc_susc = 60
    ),
    regexp = "You have failed to provide all necessary inputs"
  )
})

test_that("print.summary.complexities() returns a proper summary", {
  skip_on_cran()
  x <- capture.output(summary(complexities))
  expect_type(x, "character")
  expect_equal(x[[2]], "Mean of Complexities")
  expect_equal(x[[3]], "8.714286 ")
  expect_equal(x[[5]], "Standard Deviation of Complexities")
  expect_equal(x[[6]], "2.003568 ")
  expect_equal(x[[8]], "Standard Error of Complexities")
  expect_equal(x[[9]], "0.4372144")
})

test_that("print.hagis.complexities() returns a proper summary", {
  skip_on_cran()
  x <- capture.output(print(complexities))
  expect_type(x, "character")
  expect_equal(x[[2]], "Grouped Complexities")
  expect_equal(x[[3]], "    complexity frequency distribution")
  expect_equal(tail(x),
               c(
                 "18:     18     10",
                 "19:     19     11",
                 "20:     20     11",
                 "21:     21     13",
                 "    sample N_samp",
                 ""
               ))
})

test_that("pander.summary.complexities returns a properly formatted table", {
            skip_on_cran()
            x <- capture.output(pander(summary(complexities)))
            expect_type(x, "character")
            expect_equal(x[[1]], "")
            expect_equal(x[[2]], "------------------------")
            expect_equal(x[[3]], " Mean     SD       SE   ")
            expect_equal(x[[4]], "------- ------- --------")
            expect_equal(x[[5]], " 8.714   2.004   0.4372 ")
            expect_equal(x[[6]], "------------------------")
          })
