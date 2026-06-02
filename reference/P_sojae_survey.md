# *Phytophthora sojae* Survey Example Data

Data from a *Phytophthora sojae* survey

## Usage

``` r
data(P_sojae_survey)
```

## Format

An object of class `data.table` with 294 observations of 12 variables

- Isolate:

  *P. sojae* isolate identifier

- Line:

  Soybean cultivar

- Rps:

  *Rps* gene identifier

- Total:

  Total number of plants inoculated

- HR (1):

  Number of plants that exhibit a hypersensitive response after
  inoculation

- Lesion (2):

  Number of plants that develop a lesion at inoculation site

- Lesion to cotyledon (3):

  Number of plants that develop a lesion, which advances to the
  hypocotyl of the seedling after infection

- Dead (4):

  Number of dead plants that are observed after inoculation

- total.susc:

  The total number of susceptible plants (Lesion+Lesion to
  cotyledon+Dead)

- total.resis:

  The total number of resistant plants (equal to HR value)

## Source

Data from an ongoing 2017 *Phytophthora sojae* survey in Michigan,
conducted by A. G. McCoy *et al.*.

## Examples

``` r
if (FALSE) { # interactive()
data(P_sojae_survey)
P_sojae_survey
}
```
