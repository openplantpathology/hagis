---
title: "hagis"
output: github_document
---

<!-- badges: start -->
[![Project Status: Active – The project has reached a stable, usable state and is being actively developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)
[![CRAN\_Status\_Badge](https://www.r-pkg.org/badges/version/hagis)](https://cran.r-project.org/package=hagis)
[![codecov](https://codecov.io/gh/openplantpathology/hagis/branch/main/graph/badge.svg)](https://app.codecov.io/gh/openplantpathology/hagis)
[![DOI](https://zenodo.org/badge/164751172.svg)](https://zenodo.org/badge/latestdoi/164751172)
[![test-coverage](https://github.com/openplantpathology/hagis/actions/workflows/test-coverage.yaml/badge.svg)](https://github.com/openplantpathology/hagis/actions/workflows/test-coverage.yaml)
<!-- badges: end -->

## Introduction

The goal of {hagis} is to provide analysis tools for plant pathogens with gene-for-gene interactions in the R programming language that the original [Habgood-Gilmour Spreadsheet, HaGiS](https://doi.org/10.1046/j.1365-3059.1999.00325.x), (Herrmann, Löwer and Schachtel) provided.

This R package has been published in _MPMI_ as a resource announcement [(McCoy _et al._ 2019)](https://doi.org/10.1094/MPMI-07-19-0180-A).
You may wish to refer to that paper for further information on this package.

## Overview

{hagis} was initially created for _Phytophthora sojae_ surveys by Dr. Austin McCoy and Dr. Zachary Noel at Michigan State University in the US, where the disease has been managed primarily via deployment of resistance genes
(_Rps_ genes, resistance to _P. sojae_) in commercial soybean cultivars and by the application of fungicide seed treatments.
However, repeated use of resistance genes can cause populations to adapt over time rendering these resistance genes ineffective.
To determine current effectiveness of resistance genes for managing _P. sojae_, state-wide surveys (in the US) are conducted to determine the pathotype (previously referred to as "race") structure within sampled population of _P. sojae_.

However, the package is not only useful for _P. sojae_ work.
It was built to be useful for other plant pathogen gene-for-gene interaction systems, _e.g._, wheat rusts, but it has been used in animal science as well, see [Cain _et al._ 2022](https://doi.org/10.1186/s13071-022-05533-y).

The goal of this package is to provide all the necessary analyses needed when conducting a pathotype surveys, including: distribution of susceptibilities (effective and non-effective resistance genes), distribution of pathotype complexities with statistics, pathotype frequency distribution, as well as diversity indices for pathotypes in an efficient and reproducible manner.

New users are encouraged to visit the documentation, <https://openplantpathology.github.io/hagis/articles/hagis.html>, for detailed information on how to use {hagis} along with working examples using a built-in data set.

## Quick Start Install

### Stable Version

A CRAN version of {hagis} is available but lags behind the GitHub version.
They both will give exactly the same results.

``` r
install.packages("hagis")
```

### Development Version

A development version is available from from GitHub that may provide bug fixes or new features not yet available from CRAN.

``` r
if (!require("remotes")) {
  install.packages("remotes", repos = "http://cran.rstudio.com/")
  library("remotes")
}

install_github("openplantpathology/hagis", build_vignettes = TRUE)
```

## Meta

### Citation

When you use {hagis}, please cite by using:


```r
citation("hagis")
```

```
## Error in citation("hagis"): there is no package called 'hagis'
```

### Code of Conduct

Please note that the {hagis} project is released with a [Contributor Code of Conduct](https://contributor-covenant.org/version/2/0/CODE_OF_CONDUCT.html).
By contributing to this project, you agree to abide by its terms.

## References

> Herrmann, Löwer and Schachtel. (1999), A new tool for entry and analysis of virulence data for plant pathogens. Plant Pathology, 48: 154-158. DOI: [10.1046/j.1365-3059.1999.00325.x](https://doi.org/10.1046/j.1365-3059.1999.00325.x)

> McCoy, Noel, Sparks and Chilvers. (2019). 'hagis', an R Package Resource for Pathotype Analysis of _Phytophthora sojae_ Populations Causing Stem and Root Rot of Soybean. Molecular Plant-Microbe Interactions 32.12 (Nov 2019) p. 1574-1576. DOI: [10.1094/MPMI-07-19-0180-A](https://doi.org/10.1094/MPMI-07-19-0180-A)

> Cain, Norris, Ripley, Suri, Finnerty, Gravatte, and Nielsen, 2022. The microbial community associated with Parascaris spp. infecting juvenile horses. Parasites & Vectors, 15(1), pp.1-17. [10.1186/s13071-022-05533-y](https://doi.org/10.1186/s13071-022-05533-y)
