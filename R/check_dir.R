#' check_dir
#' 
#' @export
check_dir <- function(path) {
    if (!dir.exists(path)) {
        dir.create(path, recursive = TRUE)
    }
    path
}

#' @export
setwd2 <- function(path) {
    if (!dir.exists(path)) {
        dir.create(path, recursive = TRUE)
    }
    setwd(path)
}
