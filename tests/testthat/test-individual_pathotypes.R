data(P_sojae_survey)

diversities <- calculate_diversities(
  x = P_sojae_survey,
  cutoff = 60,
  control = "susceptible",
  sample = "Isolate",
  gene = "Rps",
  perc_susc = "perc.susc"
)

# individual_pathotypes() -----------------------------------------------------

test_that("individual_pathotypes() produces character output", {
  expect_type(
    utils::capture.output(individual_pathotypes(
      x = diversities,
      type = "text"
    )),
    "character"
  )
})

test_that("individual_pathotypes() output contains expected samples", {
  x <- utils::capture.output(individual_pathotypes(
    x = diversities,
    type = "text"
  ))
  # all isolate IDs from the source data should appear in the table
  expect_true(all(
    as.character(unique(P_sojae_survey$Isolate)) %in%
      grep("\\d", x, value = TRUE) |
      any(sapply(
        as.character(unique(P_sojae_survey$Isolate)),
        function(id) any(grepl(id, x, fixed = TRUE))
      ))
  ))
})

test_that("individual_pathotypes() output contains expected pathotype columns", {
  x <- utils::capture.output(individual_pathotypes(
    x = diversities,
    type = "text"
  ))
  expect_true(any(grepl("Sample", x, fixed = TRUE)))
  expect_true(any(grepl("Pathotype", x, fixed = TRUE)))
})

test_that("individual_pathotypes() result has correct dimensions", {
  expect_identical(nrow(diversities$individual_pathotypes), 21L)
  expect_identical(ncol(diversities$individual_pathotypes), 2L)
  expect_named(diversities$individual_pathotypes, c("Sample", "Pathotype"))
})

test_that("individual_pathotypes() pathotypes are comma-separated gene strings", {
  pathotypes <- diversities$individual_pathotypes$Pathotype
  expect_type(pathotypes, "character")
  # every pathotype string should contain only gene names present in the data
  all_genes <- as.character(
    unique(P_sojae_survey$Rps[P_sojae_survey$Rps != "susceptible"])
  )
  genes_found <- unlist(strsplit(pathotypes, ", ", fixed = TRUE))
  expect_true(all(genes_found %in% all_genes))
})

test_that("individual_pathotypes() errors when input is not a hagis.diversities object", {
  expect_error(
    individual_pathotypes("y"),
    regexp = "This is not a `hagis.diversities` object.",
    fixed = TRUE
  )
  expect_error(
    individual_pathotypes(42L),
    regexp = "This is not a `hagis.diversities` object.",
    fixed = TRUE
  )
  expect_error(
    individual_pathotypes(list(a = 1)),
    regexp = "This is not a `hagis.diversities` object.",
    fixed = TRUE
  )
})
