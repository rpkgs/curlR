#' @export
download <- function(url, outfile = NULL, overwrite = FALSE, ...) {
    if (is.null(outfile)) outfile = basename(url) %>% gsub("\\?.*", "", .)
    if (file.exists(outfile) && !overwrite) return()

    tryCatch({
        download.file(url, outfile, mode = "wb")
    }, error = function(e){
        message(e$message)
    })
}


#' @export 
aria2c <- function(infile, outdir = "OUTPUT") {
    cmd <- sprintf("aria2c -c -i %s -d %s", infile, outdir)
    print(cmd)
    system(cmd)
}
