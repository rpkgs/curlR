#' @keywords internal
"_PACKAGE"

# The following block is used by usethis to automatically manage
# roxygen namespace tags. Modify with care!
## usethis namespace: start
## usethis namespace: end
NULL


env <- environment()

init_python <- function() {
    file <- system.file("python/sendEmail.py", package = "curlR")
    reticulate::source_python(file, envir = env)
    invisible()
}

#' @importFrom reticulate source_python
.onLoad <- function(libname, pkgname) {    
}
