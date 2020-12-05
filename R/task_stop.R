#' @title Delete or stop a specific task which was scheduled in the Windows task scheduler.
#' @description Delete a specific task which was scheduled in the Windows task scheduler.
#' 
#' @param taskname the name of the task to delete. See the example.
#' @return the system call to schtasks /Delete or /End
#' 
#' @examples 
#' \dontrun{
#' myscript <- quote(print(Sys.time()))
#' task_create(taskname = "myfancyscript", rscript = myscript, 
#' schedule = "ONCE", starttime = format(Sys.time() + 10*60, "%H:%M"))
#' 
#' task_runnow("myfancyscript")
#' Sys.sleep(5)
#' task_stop("myfancyscript")
#' 
#' task_delete(taskname = "myfancyscript")
#' }
#' @export
task_stop <- function(taskname){
    
    if (.Platform$OS.type != "windows"){
        message('This function only works in windows!')
        return()
    }

    cmd <- sprintf('schtasks /End /TN %s', shQuote(taskname, type = "cmd"))
    system(cmd, intern = FALSE)
}

#' @rdname task_stop
#' @export
task_delete <- function(taskname){
    
    if (.Platform$OS.type != "windows"){
        message('This function only works in windows!')
        return()
    }

    cmd <- sprintf('schtasks /Delete /TN %s /F', shQuote(taskname, type = "cmd"))
    system(cmd, intern = FALSE)
}

#' @title Immediately run a specific task available in the Windows task scheduler.
#' @description Immediately run a specific task available in the Windows task scheduler.
#' 
#' @param taskname the name of the task to run. See the example.
#' @return the system call to schtasks /Run 
#' 
#' @examples 
#' \dontrun{
#' myscript <- quote(print(Sys.time()))
#' 
#' task_create(taskname = "myfancyscript", rscript = myscript, 
#'      schedule = "ONCE", starttime = format(Sys.time() + 10*60, "%H:%M"))
#' 
#' task_runnow("myfancyscript")
#' }
#' @export
task_runnow <- function(taskname){
    
    if (.Platform$OS.type != "windows"){
        message('This function only works in windows!')
        return()
    }

    cmd <- sprintf('schtasks /Run /TN %s', shQuote(taskname, type = "cmd"))
    system(cmd, intern = FALSE)
}
