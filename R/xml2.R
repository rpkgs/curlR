#' xml_html
#' @export
xml_html <- function(x, parse = TRUE) UseMethod("xml_html")

#' @export
#' @rdname xml_html
xml_html.webElement <- function(x, parse = TRUE) {
    text <- x$getElementAttribute("outerHTML")[[1]]
    if (!parse) {
        return(text)
    }
    read_xml(text)
}

#' @export
#' @rdname xml_html
xml_html.list <- function(x, parse = TRUE) {
    sapply(x, xml_html.webElement, parse = parse)
}

#' @export
xml_attr.list <- function(x, attr, ...) {
    sapply(x, xml_attr, attr, ...)
}

#' @title xml_text
#' @name xml_text
NULL

#' @rdname xml_text
#' @export
xml_text.webElement <- function(x){
    x$getElementText()[[1]]
}

#' @rdname xml_text
#' @export
xml_text.list <- function(x) {
    sapply(x, xml_text)
}

#' @importFrom methods show
#' @export
setMethod(f = "show",
          signature = "webElement",
          definition = function(object){
              print.webElement(object)
          })

# ' @export
# setMethod(f = "show",
#           signature = "remoteDriver",
#           definition = function(object){
#               print(object$getCurrentUrl())
#           })

# #' @export
# xml_find_all <- function(x, pattern, type = "xpath") UseMethod("xml_find_all")

#' @import xml2
#' @export
xml_find_all.remoteDriver <- function(x, pattern, type = "xpath") {
    elem <- x$findElements(type, pattern)
    lapply(elem, xml_html)
}

#' @export
xml_find_first <- function(x, pattern, type = "xpath") UseMethod("xml_find_first")

#' @export
xml_find_first.remoteDriver <- function(x, pattern, type = "xpath") {
    elem <- x$findElement(type, pattern)
    xml_html(elem)
}

# ' @export
# xml_find_all <- function(x, ...) UseMethod("xml_find_all")
#' @export
text2xml <- function(x){
    read_html(x) %>% xml_find_first("//body") %>% xml_children()
}

xml_find_class <- function(x, pattern) {
    elem <- x$findElement("class name", pattern)
    # print(elem)
    elem
}

#' @export
getElementById <- function(x, id) {
    elem <- x$findElement("id", id)
    # print(elem)
    elem
}

#' @export
print.webElement <- function(x, ...) {
    print(xml_html.webElement(x))
}
