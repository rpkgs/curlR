#' @import xml2
#' @import RSelenium
#' @import magrittr
#' @keywords internal
#' 
#' @importFrom Ipaper runningId fprintf check_dir first last listk reorder_name rm_empty which.isnull
#' @importFrom data.table data.table is.data.table
#' @importFrom plyr llply ldply
#' @importFrom utils URLdecode download.file read.csv
#' @importFrom stats setNames
#' @importFrom stringr str_extract str_split
"_PACKAGE"

# The following block is used by usethis to automatically manage
# roxygen namespace tags. Modify with care!
## usethis namespace: start
## usethis namespace: end
NULL


# env <- environment()
# #' @export 
# init_python <- function() {
#     env <- environment(.onLoad)
#     invisible()
# }

#' @importFrom reticulate source_python
.onLoad <- function(libname, pkgname) {
    if(getRversion() >= "2.15.1") {
        utils::globalVariables(
            c(".", "timenum", "timeinfo", "TaskName", "time", "res", "sendEmail_py")
        )
    }
}
