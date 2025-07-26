
---
output: github_document
---

<!-- README.md is generated from README.Rmd. Please edit that file -->



# {hagis}: Analysis of Plant (and Animal) Pathogen Pathotype Complexities, Distributions and Diversity
    
<!-- badges: start -->

[![Project Status: Active – The project has reached a stable, usable state and is being actively developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active) 
[![Codecov test coverage](https://codecov.io/gh/openplantpathology/hagis/branch/main/graph/badge.svg)](https://app.codecov.io/gh/openplantpathology/hagis?branch=main)
[![CRAN_Status_Badge](https://www.r-pkg.org/badges/version/hagis)](https://cran.r-project.org/package=hagis)  [![DOI](https://zenodo.org/badge/164751172.svg)](https://zenodo.org/badge/latestdoi/164751172) [![test-coverage](https://github.com/openplantpathology/hagis/actions/workflows/test-coverage.yaml/badge.svg)](https://github.com/openplantpathology/hagis/actions/workflows/test-coverage.yaml)
<!-- badges: end -->

## Introduction

The goal of {hagis} is to provide analysis tools for plant pathogens with gene-for-gene interactions in the R programming language that the original [Habgood-Gilmour Spreadsheet, HaGiS](https://doi.org/10.1046/j.1365-3059.1999.00325.x), (Herrmann, Löwer and Schachtel) provided.

This R package has been published in *MPMI* as a resource announcement [(McCoy *et al.* 2019)](https://doi.org/10.1094/MPMI-07-19-0180-A).
You may wish to refer to that paper for further information on this package.

## Overview

{hagis} was initially created for *Phytophthora sojae* surveys by Dr. Austin McCoy and Dr. Zachary Noel at Michigan State University in the US, where the disease has been managed primarily via deployment of resistance genes (*Rps* genes, resistance to *P. sojae*) in commercial soybean cultivars and by the application of fungicide seed treatments.
However, repeated use of resistance genes can cause populations to adapt over time rendering these resistance genes ineffective.
To determine current effectiveness of resistance genes for managing *P. sojae*, state-wide surveys (in the US) are conducted to determine the pathotype (previously referred to as "race") structure within sampled population of *P. sojae*.

However, the package is not only useful for *P. sojae* work.
It was built to be useful for other plant pathogen gene-for-gene interaction systems, *e.g.*, wheat rusts, but it has been used in animal science as well, see [Cain *et al.* 2022](https://doi.org/10.1186/s13071-022-05533-y).

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
o <- options() # store default options

options(pkg.build_vignettes = TRUE)
if (!require("pak")) {
  install.packages("pak", repos = "http://cran.rstudio.com/")
  library("pak")
}

pak("openplantpathology/hagis", build_vignettes = TRUE)
options(o) # reset options
```

## Meta

### Citation

When you use {hagis}, please cite by using:


``` r
citation("hagis")
#> To cite package 'hagis' in publications use:
#> 
#>   McCoy AG, Noel ZA, Sparks AH, Chilvers M (2019). "hagis, an R Package
#>   Resource for Pathotype Analysis of Phytophthora sojae Populations
#>   Causing Stem and Root Rot of Soybean." _Molecular Plant-Microbe
#>   Interactions_, *32*(12), 1574–1576. doi:10.1094/MPMI-07-19-0180-A
#>   <https://doi.org/10.1094/MPMI-07-19-0180-A>,
#>   <https://doi.org/10.1094/MPMI-07-19-0180-A>.
#> 
#>   McCoy AG, Noel ZA, Sparks AH, Chilvers MI (????). _hagis: Analysis of
#>   Plant Pathogen Pathotype Complexities, Distributions and Diversity_.
#>   doi:10.5281/zenodo.2619820 <https://doi.org/10.5281/zenodo.2619820>,
#>   R package version 4.0.0,
#>   <https://openplantpathology.github.io/hagis/>.
#> 
#> To see these entries in BibTeX format, use 'print(<citation>,
#> bibtex=TRUE)', 'toBibtex(.)', or set
#> 'options(citation.bibtex.max=999)'.
```

### Code of Conduct

Please note that the {hagis} project is released with a [Contributor Code of Conduct](https://contributor-covenant.org/version/2/0/CODE_OF_CONDUCT.html).
By contributing to this project, you agree to abide by its terms.

## References

> Herrmann, Löwer and Schachtel. (1999), A new tool for entry and analysis of virulence data for plant pathogens. Plant Pathology, 48: 154-158. DOI: [10.1046/j.1365-3059.1999.00325.x](https://doi.org/10.1046/j.1365-3059.1999.00325.x)

> McCoy, Noel, Sparks and Chilvers. (2019). 'hagis', an R Package Resource for Pathotype Analysis of _Phytophthora sojae_ Populations Causing Stem and Root Rot of Soybean. Molecular Plant-Microbe Interactions 32.12 (Nov 2019) p. 1574-1576. DOI: [10.1094/MPMI-07-19-0180-A](https://doi.org/10.1094/MPMI-07-19-0180-A)

> Cain, Norris, Ripley, Suri, Finnerty, Gravatte, and Nielsen, 2022. The microbial community associated with _Parascaris_ spp. infecting juvenile horses. Parasites & Vectors, 15(1), pp.1-17. [10.1186/s13071-022-05533-y](https://doi.org/10.1186/s13071-022-05533-y)
