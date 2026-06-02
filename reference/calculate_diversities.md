# Calculate Diversities Indices

Calculate five pathogen diversity indices.

Diversity indices include:

- Simple diversity index, which will show the proportion of unique
  pathotypes to total samples. As the values gets closer to 1, there is
  greater diversity in pathoypes within the population. Simple diversity
  is calculated as: \$\$ D = \frac{Np}{Ns} \$\$ where \\Np\\ is the
  number of pathotypes and \\Ns\\ is the number of samples.

- Gleason diversity index, an alternate version of Simple diversity
  index, is less sensitive to sample size than the Simple index. \$\$ D
  = \frac{ (Np - 1) }{ log(Ns)}\$\$ Where \\Np\\ is the number of
  pathotypes and \\Ns\\ is the number of samples.

- Shannon diversity index is typically between 1.5 and 3.5, as richness
  and evenness of the population increase, so does the Shannon index
  value. \$\$ D = -\sum\_{i = 1}^{R} p_i \log p_i \$\$ Where \\p_i\\ is
  the proportional abundance of species \\i\\.

- Simpson diversity index values range from 0 to 1, 1 represents high
  diversity and 0 represents no diversity. Where diversity is calculated
  as: \$\$ D = \sum\_{i = 1}^{R} p_i^2 \$\$

- Evenness ranges from 0 to 1, as the Evenness value approaches 1, there
  is a more even distribution of each pathoype's frequency within the
  population. Where Evenness is calculated as: \$\$ D =
  \frac{H'}{log(Np) }\$\$ where \\H'\\ is the Shannon diversity index
  and \\Np\\ is the number of pathotypes.

## Usage

``` r
calculate_diversities(x, cutoff, control, sample, gene, perc_susc)
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

A `hagis.diversities` object.

A `hagis.diversities` object is a `list` containing:

- Number of Samples

- Number of Pathotypes

- Simple Diversity Index

- Gleason Diversity Index

- Shannon Diversity Index

- Simpson Diversity Index

- Evenness Diversity Index

## Examples

``` r
if (FALSE) { # interactive()
# Using the built-in data set, P_sojae_survey
data(P_sojae_survey)

P_sojae_survey

# calculate susceptibilities with a 60 % cutoff value
diversities <- calculate_diversities(
  x = P_sojae_survey,
  cutoff = 60,
  control = "susceptible",
  sample = "Isolate",
  gene = "Rps",
  perc_susc = "perc.susc"
)

diversities
}
```
