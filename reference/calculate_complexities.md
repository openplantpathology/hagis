# Calculate Distribution of Complexities by Sample

Calculate the distribution of susceptibilities by sample id.

## Usage

``` r
calculate_complexities(x, cutoff, control, sample, gene, perc_susc)
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

An object of class `hagis.complexities`.

An object of class `hagis.complexities` is a `list` containing the
following components

- grouped_complexities:

  a
  [`data.table::data.table()`](https://rdrr.io/pkg/data.table/man/data.table.html)
  object of grouped complexities

- individual_complexities:

  a
  [`data.table::data.table()`](https://rdrr.io/pkg/data.table/man/data.table.html)
  object of individual complexities

## Examples

``` r
if (FALSE) { # interactive()

# Using the built-in data set, `P_sojae_survey`
data(P_sojae_survey)

P_sojae_survey

# calculate susceptibilities with a 60 % cutoff value
complexities <- calculate_complexities(
  x = P_sojae_survey,
  cutoff = 60,
  control = "susceptible",
  sample = "Isolate",
  gene = "Rps",
  perc_susc = "perc.susc"
)
complexities

summary(complexities)
}
```
