# FirstRPackage

The goal of FirstRPackage is to ...

## Installation

You can install FirstRPackage from github with:


``` r
# install.packages("devtools")
devtools::install_github("aditya9352/FirstRPackage")
```

## Example

This is a basic example which shows you how to solve a common problem:

This package helps users to read the files in the directory and summarise number of accidents by month and year. The package contains the functions fars_read(), make_filename(), fars_read_years(), fars_summarize_years() and fars_map_state().

We'll be explaining each function with examples.

### fars_read()

This is a simple function that reads a file by taking filename as input. If a filename doesn't exist in the working directory then the function stops with the message "file 'filename' does not exist".

``` r
fars_read('accident_2013.csv.bz2')

```

### make_filename()

This is a simple function that creates a filename in the ".csv.bz2" format starting with "accident_" for a given year.

``` r
make_filename(2018)
```

### fars_read_years()

This function let's us read multiple files by just inputting the years for which we want to read files. It generates a list of data frames, where each file is a data frame that's part of the list.

``` r
fars_read_years(c(2013, 2014, 2015))
```

### fars_summarize_years()

This function calculates a summary of total accidents by month and year.

``` r
fars_summarize_years(c(2013, 2014, 2015))
```

### fars_map_state()

This function let's us show accidents by exact location in a state within a year on a map. If there are no accidents for a state in a year, then a message "no accidents to plot" would vbe shown. The "state.num" should be valid otherwise the function would stop and show the message "invalid STATE number: 'state.num'".

``` r
fars_map_state(24, 2013)
```
