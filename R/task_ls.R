#' @title Get all the tasks which are currently scheduled at the Windows task scheduler.
#' @description Get all the tasks which are currently scheduled at the Windows task scheduler.
#'
#' @inheritParams task_create
#' @param encoding encoding of the CSV which schtasks.exe generates. Defaults to UTF-8.
#' @param ... optional arguments passed on to \code{fread} in order to read in the CSV file which schtasks generates
#' @param wildcard boolean, whether use regexpr to match task?
#' 
#' @return a data.frame with scheduled tasks as returned by schtasks /Query for which the Taskname or second
#' column in the dataset the preceding \\ is removed
#' 
#' @examples
#' \dontrun{
#' d <- task_ls()
#' d
#' }
#' @export
task_ls <- function(taskname = NULL, wildcard = FALSE, encoding = 'UTF-8', ...){
    
    if (.Platform$OS.type != "windows"){
        message('This function only works in windows!')
        return()
    }

    change_code_page <- system("chcp 65001", intern = TRUE)
    pattern <- "*"
    if (wildcard ) {
        if (!is.null(taskname)){
            pattern <- taskname
            taskname <- NULL
        }
        # test whether pattern is valid
        temp <- grep(pattern, "")
    }

    cmd <- sprintf('schtasks /Query /FO CSV /V')
    if (!is.null(taskname))
        cmd <- sprintf("%s /TN %s", cmd, taskname)
    # print(cmd)
    str <- system(cmd, intern = TRUE)

    filepath <- tempfile()
    on.exit(file.remove(filepath))

    writeLines(str, filepath)

    df <- suppressWarnings({ try(data.table::fread(filepath, encoding = encoding, ...), silent = TRUE) })

    if(inherits(df, "try-error")){
        df <- utils::read.csv(filepath, check.names = FALSE,
            stringsAsFactors=FALSE, encoding = encoding, ...) %>% data.table()
    }

    if(!("TaskName" %in% names(df))) 
        try(colnames(df)[2] <- "TaskName", silent = TRUE)
    try(df$TaskName %<>% gsub("^\\\\", "", .), silent = TRUE)

    if (wildcard) {
        if (nrow(df) > 0) df <- df[grep(pattern, TaskName)]
    }
    df
}
