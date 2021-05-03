#' @export
setwd2 <- function(path) {
    if (!dir.exists(path)) {
        dir.create(path, recursive = TRUE)
    }
    setwd(path)
}
