#' @export
clickElement <- function(x) {
    x$clickElement()
}

#' @export
send_keys <- function(x, value) {
    x$clearElement()
    x$sendKeysToElement(list(value))
    x
}

#' @export
set_text <- function(x, value) {
    x$clearElement()
    send_keys(x, value)
}

#' @export
focus_first_window <- function(p) {
    # TODO: fix here
    handles <- p$getWindowHandles() %>% sapply(self)
    p$switchToWindow(first(handles))
}

#' @export
focus_last_window <- function(p) {
    handles <- p$getWindowHandles() %>% sapply(self)
    p$switchToWindow(last(handles))
}

