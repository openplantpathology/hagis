# Check User Inputs

Checks and validates user inputs before running functions

## Usage

``` r
.check_inputs(.x, .cutoff, .control, .sample, .gene, .perc_susc)
```

## Arguments

- .x:

  a `data.table` containing the values to be summarised

- .cutoff:

  value for percent susceptible cutoff. Numeric.

- .control:

  value used to denote the susceptible control in the `gene` column.
  Character.

- .sample:

  column providing the unique identification for each sample being
  tested. Character.

- .gene:

  column providing the gene(s) being tested. Character.

- .perc_susc:

  column providing the percent susceptible reactions as a numeric value.
  Character.
