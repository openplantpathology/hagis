# Create Binary Data Matrix From Pathotype Data

Creates a binary data matrix from pathotype data representing the
pathotype of each isolate. This binary data matrix can be used to
visualize beta-diversity of pathotypes using
[vegan](https://CRAN.R-project.org/package=vegan) and
[ape](https://CRAN.R-project.org/package=ape).

## Usage

``` r
create_binary_matrix(x, cutoff, control, sample, gene, perc_susc)
```

## Arguments

- x:

  a `data.frame` containing the data.

- cutoff:

  value for percent susceptible cutoff. `Numeric`.

- control:

  value used to denote the susceptible control in the `gene` column.
  `Character`.

- sample:

  column providing the unique identification for each sample being
  tested. `Character`.

- gene:

  column providing the gene(s) being tested. `Character`.

- perc_susc:

  column providing the percent susceptible reactions. `Character`.

## Value

a binary matrix of pathotype data

## Examples

``` r
if (FALSE) { # interactive()

# Using the built-in data set, `P_sojae_survey`
data(P_sojae_survey)

P_sojae_survey

# calculate susceptibilities with a 60 % cutoff value
final_matrix <- create_binary_matrix(x = P_sojae_survey,
                                    cutoff = 60,
                                    control = "susceptible",
                                    sample = "Isolate",
                                    gene = "Rps",
                                    perc_susc = "perc.susc")
final_matrix
}
```
