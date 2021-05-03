#' write_quote
#'
#' @return file path of `rscript`
#' @export
write_quote <- function(rscript, outfile, 
    header = c("#! /usr/bin/Rscript \nlibrary(ChinaWater); library(lubridate); print(getwd());")) 
{
    if (typeof(rscript) == "language"){ # quoteobj
        scripts <- deparse(rscript)
        nline   <- length(scripts)

        scripts <- gsub("^ {4}", "", scripts[2:(nline-1)]) %>% c(header, .)

        writeLines(scripts, outfile)
        # change rscipt to filepath
        rscript <- outfile
    }
    rscript
}
