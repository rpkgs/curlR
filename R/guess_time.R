# in the unit of second
#' @title time functions
#' @name time2num
#' 
#' @export
time2num <- function(time) as.numeric(num2time(time))


#' @export
#' @rdname time2num
num2time <- function(num) {
    as.POSIXct(num, origin = "1970-01-01")
}

#' @rdname time2num
#' @export
time2str <- function(time) format(time, format = "%Y-%m-%d %H:%M:%S")

#' @export
timeinfo <- function(time) {
    data.table(
        year = year(time), month = month(time), day = day(time), hour = hour(time),
        time = time2str(time), timenum = time2num(time)
    )
}

# "%Y%m%d-%H%M%S"
#' @export
guess_time <- function(file, format = "%Y-%m-%d_%H00") {
    str <- str_extract(basename(file), "\\d{4}-\\d{2}-\\d{2}_\\d{4}") # "1998-01-01_0100"
    as.POSIXct(str, format = format) %>% format("%Y-%m-%d %H:%M:%S")
    # "%Y-%m-%d_%H00"
}
