#' RETRY2
#' @examples
#' RETRY2(1)
#' # RETRY2(stop(1))
#' 
#' @export
RETRY2 <- function(expr, sec = 1, times = 10){
    res <- NULL
    for (i in 1:times) {
        ans <- tryCatch({
            res <- eval(expr)
            break
        }, error = function(e) {
            cat(sprintf('  | %d_th times retry ...\n', i))
            Sys.sleep(sec)
        })
    }
    res
}
