#' Read file
#'
#' This is a simple function that reads a file by taking filename as input. If a filename doesn't exist in the working directory then the function
#' stops with the message "file 'filename' does not exist".
#'
#' @importFrom readr read_csv
#' @importFrom dplyr tbl_df
#'
#' @param filename A character string specifying the filename that needs to be read.
#'
#' @return A data frame containing a representation of the data in the file.
#'
#' @example fars_read('accident_2013.csv.bz2')
#'
#' @export
fars_read <- function(filename) {
  if(!file.exists(filename))
    stop("file '", filename, "' does not exist")
  data <- suppressMessages({
    readr::read_csv(filename, progress = FALSE)
  })
  dplyr::tbl_df(data)
}

#' Create filename
#'
#' This is a simple function that creates a filename in the ".csv.bz2" format starting with "accident_" for a given year.
#'
#' @param year The year for which you want to create the filename.
#'
#' @return A filename for the given year.
#'
#' @example make_filename(2018)
#'
#' @export
make_filename <- function(year) {
  year <- as.integer(year)
  sprintf("accident_%d.csv.bz2", year)
}

#' Read multiple files
#'
#' This function let's us read multiple files by just inputting the years for which we want to read files. It generates a list of data frames,
#' where each file is a data frame that's part of the list.
#'
#' @import magrittr
#' @importFrom dplyr mutate select
#'
#' @param years A vector of years.
#'
#' @return A list of data frames.
#'
#' @example fars_read_years(c(2013, 2014, 2015))
#'
#' @export
fars_read_years <- function(years) {
  require(magrittr)
  lapply(years, function(year) {
    file <- make_filename(year)
    tryCatch({
      dat <- fars_read(file)
      dplyr::mutate(dat, year = year) %>%
        dplyr::select(MONTH, year)
    }, error = function(e) {
      warning("invalid year: ", year)
      return(NULL)
    })
  })
}

#' Create summary by month and year
#'
#' This function calculates a summary of total accidents by month and year.
#'
#' @importFrom dplyr bind_rows group_by summarize
#' @importFrom tidyr spread
#'
#' @inheritParams fars_read_years
#'
#' @return A data frame summarising number of accidents by month and year.
#'
#' @example fars_summarize_years(c(2013, 2014, 2015))
#'
#' @export
fars_summarize_years <- function(years) {
  dat_list <- fars_read_years(years)
  dplyr::bind_rows(dat_list) %>%
    dplyr::group_by(year, MONTH) %>%
    dplyr::summarize(n = n()) %>%
    tidyr::spread(year, n)
}

#' Plot accidents within a state on the map.
#'
#' This function let's us show accidents by exact location in a state within a year on a map. If there are no accidents for a state in a year,
#' then a message "no accidents to plot" would vbe shown. The "state.num" should be valid otherwise the function would stop
#' and show the message "invalid STATE number: 'state.num'".
#'
#' @importFrom dplyr filter
#' @importFrom maps map
#' @importFrom graphics points
#'
#' @param state.num The state number for which we want to plot accidents on the map.
#' @param year The year for which we want to look at accidents on the map.
#'
#' @return A map with accidents plotted on the map for the selected year and state number.
#'
#' @example fars_map_state(24, 2013)
#'
#' @export
fars_map_state <- function(state.num, year) {
  filename <- make_filename(year)
  data <- fars_read(filename)
  state.num <- as.integer(state.num)

  if(!(state.num %in% unique(data$STATE)))
    stop("invalid STATE number: ", state.num)
  data.sub <- dplyr::filter(data, STATE == state.num)
  if(nrow(data.sub) == 0L) {
    message("no accidents to plot")
    return(invisible(NULL))
  }
  is.na(data.sub$LONGITUD) <- data.sub$LONGITUD > 900
  is.na(data.sub$LATITUDE) <- data.sub$LATITUDE > 90
  with(data.sub, {
    maps::map("state", ylim = range(LATITUDE, na.rm = TRUE),
              xlim = range(LONGITUD, na.rm = TRUE))
    graphics::points(LONGITUD, LATITUDE, pch = 46)
  })
}
