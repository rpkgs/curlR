#' @export
xml_text.webElement <- function(x){
    x$getElementText()[[1]]
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

#' @export
xml_html <- function(x, parse = TRUE) UseMethod("xml_html")

# ' @export
# xml_find_all <- function(x, ...) UseMethod("xml_find_all")

#' @export
xml_html.webElement <- function(x, parse = TRUE){
    text <- x$getElementAttribute("outerHTML")[[1]]
    if (!parse) return(text)
    read_xml(text)
}

xml_html.list <- function(x, parse = TRUE) {
    sapply(x, xml_html.webElement, parse = parse)    
}

#' @export
text2xml <- function(x){
    read_html(x) %>% xml_find_first("//body") %>% xml_children()
}

#' @export
xml_find_first.remoteDriver <- function(x, pattern, type = "xpath"){
    elem <- x$findElement(type, pattern)
    # print(elem)
    elem
}

xml_find_class <-function(x, pattern) {
    elem <- x$findElement("class name", pattern)
    # print(elem)
    elem
}

#' @export
xml_find_all <- function(x, pattern, type = "xpath"){
    elem <- x$findElements(type, pattern)
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
