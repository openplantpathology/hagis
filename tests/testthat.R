library("testthat")
library("vdiffr")
library("hagis")


if (Sys.getenv("NOT_CRAN") == "true") {
  # like global skip_on_cran
  # https://github.com/r-lib/testthat/issues/144#issuecomment-396902791
  # according to https://github.com/hadley/testthat/issues/144
  Sys.setenv("R_TESTS" = "")
  test_check("hagis")
}
