# test summarize_gene_pi() ----------------------------------------------------

data(P_sojae_survey)

test_that("summarize_gene_pi() returns correct structure", {
  x <- summarize_gene_pi(
    x = P_sojae_survey,
    max_score = 100,
    control = "susceptible",
    sample = "Isolate",
    gene = "Rps",
    perc_susc = "perc.susc"
  )

  expect_s3_class(x, "hagis.gene.pi")
  expect_named(
    x,
    c(
      "gene",
      "sum_scores",
      "pathogenicity_index",
      "pathogenicity_index_percent"
    )
  )
})

test_that("summarize_gene_pi() returns values in valid ranges", {
  x <- summarize_gene_pi(
    x = P_sojae_survey,
    max_score = 100,
    control = "susceptible",
    sample = "Isolate",
    gene = "Rps",
    perc_susc = "perc.susc"
  )

  expect_true(all(x$pathogenicity_index >= 0))
  expect_true(all(x$pathogenicity_index <= 1))
  expect_true(all(x$pathogenicity_index_percent >= 0))
  expect_true(all(x$pathogenicity_index_percent <= 100))
})

test_that("summarize_gene_pi() errors on invalid max_score", {
  expect_error(
    summarize_gene_pi(
      x = P_sojae_survey,
      max_score = NULL,
      control = "susceptible",
      sample = "Isolate",
      gene = "Rps",
      perc_susc = "perc.susc"
    ),
    regexp = "`max_score` must be a single positive numeric value.",
    fixed = TRUE
  )

  expect_error(
    summarize_gene_pi(
      x = P_sojae_survey,
      max_score = -1,
      control = "susceptible",
      sample = "Isolate",
      gene = "Rps",
      perc_susc = "perc.susc"
    ),
    regexp = "`max_score` must be a single positive numeric value.",
    fixed = TRUE
  )
})

test_that("summarize_gene_pi() matches hand calculation", {
  toy <- data.frame(
    sample = c("A", "B", "C", "A", "B", "C", "A", "B", "C"),
    gene = c(
      "G1",
      "G1",
      "G1",
      "G2",
      "G2",
      "G2",
      "susceptible",
      "susceptible",
      "susceptible"
    ),
    score = c(4, 3, 1, 0, 2, 4, 4, 4, 4)
  )

  x <- summarize_gene_pi(
    x = toy,
    max_score = 4,
    control = "susceptible",
    sample = "sample",
    gene = "gene",
    perc_susc = "score"
  )

  expect_equal(x[gene == "G1"]$sum_scores, 8)
  expect_equal(x[gene == "G1"]$pathogenicity_index, 8 / (4 * 3))
  expect_equal(x[gene == "G1"]$pathogenicity_index_percent, 100 * 8 / (4 * 3))

  expect_equal(x[gene == "G2"]$sum_scores, 6)
  expect_equal(x[gene == "G2"]$pathogenicity_index, 6 / (4 * 3))
  expect_equal(x[gene == "G2"]$pathogenicity_index_percent, 100 * 6 / (4 * 3))
})
