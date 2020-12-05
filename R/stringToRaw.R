
#' convert Raw format string into the real raw format variable
#'
#' @param str format string
#' @return raw vector
#'
#' @examples
#' \dontrun{
#' key_p <- "EB2A38568661887FA180BDDB5CABD5F21C7BFD59C090CB2D245A87AC253062882729
#' 293E5506350508E7F9AA3BB77F4333231490F915F6D63C55FE2F08A49B353F444AD3993CACC02D
#' B784ABBB8E42A9B1BBFFFB38BE18D78E87A0E41B9B8F73A928EE0CCEE1F6739884B9777E4FE9E88A
#' 1BBE495927AC4A799B3181D6442443"
#' stringToRaw(key_p)
#' }
#' @export
stringToRaw <- function(str) {
    string <- raw()
    str %<>% gsub("\n| ", "", .)
    for (i in 1:(nchar(str) / 2)) {
        string[i] <- substr(str, (2 * i - 1), (2 * i)) %>%
            as.hexmode() %>%
            unlist() %>%
            as.raw()
    }
    return(string)
}
