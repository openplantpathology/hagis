# Calculate and Summarize Distribution of Susceptibilities by Gene

Calculate the distribution of susceptibilities by gene.

## Usage

``` r
summarize_gene(x, cutoff, control, sample, gene, perc_susc)
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

a `hagis.gene.summary` object.

An object of class `hagis.gene.summary` is a  
[`data.table::data.table()`](https://rdrr.io/pkg/data.table/man/data.table.html)
containing the following components columns

- gene:

  the gene

- N_virulent_isolates:

  the total number virulent isolates for a given gene in the `gene`
  column

- percent_pathogenic:

  the frequency with which a gene is pathogenic

## Examples

``` r
if (FALSE) { # interactive()
# Using the built-in data set, `P_sojae_survey`
data(P_sojae_survey)

P_sojae_survey

# calculate susceptibilities with a 60 % cutoff value
susc <- summarize_gene(
  x = P_sojae_survey,
  cutoff = 60,
  control = "susceptible",
  sample = "Isolate",
  gene = "Rps",
  perc_susc = "perc.susc"
)
susc
}
```
