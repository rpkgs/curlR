#' split into nchunks
#'
#' @param x numeric vector or list
#' @param nchunk integer
#'
#' @export
chunk <- function(x, nchunk) {
    len <- length(x)
    if (nchunk == 1) {
        list(x)
    } else {
        split(x, cut(seq_along(x), nchunk, labels = FALSE))
    }
}

runningId <- function(i, step = 1, N, prefix = "") {
    perc <- ifelse(missing(N), "", sprintf(", %.1f%% ", i / N * 100))
    if (mod(i, step) == 0) cat(sprintf("%srunning%s %d ...\n", prefix, perc, i))
}

# ------------------------------------------------------------------------------
#' xml_json
#' @param x request object
#' 
#' @importFrom jsonlite fromJSON
#' @export
xml_json <- function(x) {
    content(x, encoding = "utf-8") %>%
        xml_text() %>%
        fromJSON()
}

#' @export
xml_check <- function(x) {
    if (class(x)[1] %in% c("xml_document", "xml_node")) x else read_html(x)
}

#' html_inputs
#' @param p requested object from httr
#' @param xpath A string containing a xpath (1.0) expression.
#'
#' @export
html_inputs <- function(p, xpath = "//input") {
    xml_check(p) %>%
        xml_find_all(xpath) %>%
        {
            setNames(as.list(xml_attr(., "value")), xml_attr(., "name"))
        }
}


#' @export
save_html <- function(x, file = "kong.html") write_xml(xml_check(x), file)

html_body <- function(p, xpath = "//body") xml_find_all(xml_check(p), xpath)

#' @export
getElementById <- function(p, Id) xml_check(p) %>% xml_find_all(sprintf("//*[@id='%s']", Id))

#' @export
getElementByName <- function(p, Id) xml_check(p) %>% xml_find_all(sprintf("//*[@name='%s']", Id))
