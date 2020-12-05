#' @import lubridate
#' @export
add_month <- function(x, n) {
    year  <- year(x)
    month <- month(x)
    day   <- day(x)

    month <- month + n
    if (month > 12) {
        year  <- year + floor( (month - 1)/12)
        month <- ((month - 1) %% 12) + 1
    }
    make_date(year, month, day)
}

#' @export
seq_month <- function(date_begin, date_end, by = 12){
    dates = seq(date_begin, date_end, by = "month")
    dates[seq(1, length(dates), by)]
}

#' timestamp
#'
#' @return time stamp, just like 1498029994455 (length of 13)
#' @export
timestamp <- function() as.character(floor(as.numeric(Sys.time()) * 1000))

#' @rdname timestamp
#' @export
datestamp <- timestamp

#' @export
millisec2date <- function(x, scale = 1000) {
    if (is.character(x)) x <- as.numeric(x)
    as.POSIXct(x / scale, origin = "1970-01-01") %>% as.Date(tz = "")
}
