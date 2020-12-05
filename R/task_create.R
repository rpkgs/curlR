#' Schedule an R script with the Windows task scheduler.
#'
#' @description Schedule an R script with the Windows task scheduler. E.g. daily,
#' weekly, once, at startup, ...
#'
#' More information about the scheduling format can be found in the docs/schtasks.pdf
#' file inside this package. The rscript file will be scheduled with Rscript.exe and
#' the log of the run will be put in the .log file which can be found in the same directory
#' as the location of the rscript.
#'
#' @param rscript filepath or \code{\link{quote}} object. Should not contain any spaces.
#' @param taskname a character string with the name of the task. Defaults to the filename. Should not contain any spaces.
#' @param workdir working directory
#'
#' @param schedule when to schedule the \code{rscript}.
#' Either one of 'ONCE', 'MONTHLY', 'WEEKLY', 'DAILY', 'HOURLY', 'MINUTE', 'ONLOGON', 'ONIDLE'.
#' @param starttime a timepoint in HH:mm format indicating when to run the script. Defaults to within 62 seconds.
#' @param startdate a date that specifies the first date on which to run the task.
#' Only applicable if schedule is of type 'MONTHLY', 'WEEKLY', 'DAILY', 'HOURLY', 'MINUTE'. Defaults to today in '\%d/\%m/\%Y' format. Change to your locale format if needed.
#' @param days character string with days on which to run the script if schedule is 'WEEKLY' or 'MONTHLY'. Possible values
#' are * (all days). For weekly: 'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN' or a vector of these in your locale.
#' For monthly: 1:31 or a vector of these.
#' @param months character string with months on which to run the script if schedule is 'MONTHLY'. Possible values
#' are * (all months) or 'JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN', 'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC' or a vector of these in your locale.
#' @param modifier integer, a modifier to apply. See the docs/schtasks.pdf
#' @param idletime integer, containing a value that specifies the amount of idle time to wait before
#' running a scheduled ONIDLE task. The valid range is 1 - 999 minutes.
#' @param Rexe path to Rscript.exe which will be used to run the script. Defaults to Rscript at the bin folder of R_HOME.
#' @param rscript_args character string with further arguments passed on to Rscript. See args in \code{\link{Rscript}}.
#' @param schtasks_extra character string with further schtasks arguments. See the inst/docs/schtasks.pdf
#' If you want to hide the cmd popuping windows, you need to pass
#' \code{'/RU "username" /RP "passwd"'} to schtasks_extra.
#'
#' @param debug logical
#'
#' @return the system call to schtasks /Create
#'
#' @example man/examples/ex-task_create.R
#'
#' @references
#' "taskscheduleR::taskscheduler_create".
#'
#' @export
task_create <- function (
    rscript = quote(print(Sys.time())),
    taskname = NULL,
    workdir = "./task",
    schedule = c("ONCE", "MINUTE", "HOURLY", "DAILY", "WEEKLY", "MONTHLY", "ONLOGON", "ONIDLE"),
    starttime = format(Sys.time() + 61, "%H:%M"),
    startdate = format(Sys.Date(), "%Y/%m/%d"),
    days = c("*", "MON", "TUE", "WED", "THU", "FRI", "SAT", "SUN", 1:31),
    months = c("*", "JAN", "FEB", "MAR", "APR", "MAY", "JUN", "JUL", "AUG",
        "SEP", "OCT", "NOV", "DEC"),
    modifier,
    idletime = 60L,
    Rexe = file.path(Sys.getenv("R_HOME"), "bin", "Rscript.exe"),
    rscript_args = "",
    schtasks_extra = "",
    debug = FALSE)
{
    if (.Platform$OS.type != "windows"){
        message('This function only works in windows!')
        return()
    }

    ## check parameters
    workdir %<>% check_dir() %>% normalizePath()

    if (is.character(rscript)) { # file path
        if (is.null(taskname)) {
            taskname <- basename(taskname) %>% paste0("R_task_", .)
        }
    }
    if (is.null(taskname)) taskname <- "R_task"

    outfile <- sprintf("%s/%s.R", workdir, taskname)
    rscript <- write_quote(rscript, outfile)

    if (!file.exists(rscript)) { stop(sprintf("File %s does not exist", rscript)) }
    rscript %<>% normalizePath()

    schedule <- match.arg(schedule)

    check_timeFreq <- function(x) { ifelse("*" %in% x, "*", paste(x, collapse = ",")) }

    days   %<>% check_timeFreq()
    months %<>% check_timeFreq()

    taskname <- force(taskname)
    if (length(grep(" ", taskname)) > 0) {
        taskname <- gsub(" ", "-", taskname)
        message(sprintf("No spaces are allowed in taskname, changing the name of the task to %s",
            taskname))
    }
    # no space allowed in rscript
    if (length(grep(" ", rscript)) > 0) {
        message(sprintf("Full path to filename '%s' contains spaces, it is advised to put your script in another location which contains no spaces",
            rscript))
    }

    task <- sprintf("cmd /c %s & cd %s & %s %s %s > %s 2>&1",
        substr(workdir, 1, 2), workdir,
        Rexe,
        shQuote(rscript), paste(rscript_args, collapse = " "),
        shQuote(sprintf("%s.log", tools::file_path_sans_ext(rscript))))
    if (nchar(task) > 260) {
        warning(sprintf("Passing on this to the TR argument of schtasks.exe: %s, this is too long. Consider putting your scripts into another folder",
            task))
    }

    cmd <- sprintf("schtasks /Create /F /TN %s /TR %s /SC %s",
        shQuote(taskname, type = "cmd"),
        shQuote(task, type = "cmd"), schedule)

    # TIMES
    if (!missing(modifier) && !(schedule %in% c("ONLOGON", "ONIDLE", "ONCE"))){
        cmd <- sprintf("%s /MO %s", cmd, modifier)
    }

    if (schedule %in% "ONCE") starttime <- "00:00"

    if (schedule %in% c("ONIDLE"))
        cmd <- sprintf("%s /I %s", cmd, idletime)

    if (!schedule %in% c("ONLOGON", "ONIDLE")) # "ONCE"
        cmd <- sprintf("%s /ST %s", cmd, starttime)

    if (!schedule %in% c("ONLOGON", "ONIDLE"))
        cmd <- sprintf("%s /SD %s", cmd, shQuote(startdate))

    if (schedule %in% c("WEEKLY", "MONTHLY"))
        cmd <- sprintf("%s /D %s", cmd, days)

    if (schedule %in% c("MONTHLY"))
        cmd <- sprintf("%s /M %s", cmd, months)

    cmd <- sprintf("%s %s", cmd, schtasks_extra)

    cat(sprintf('Creating task schedule:\n'))
    cat(sprintf('-----------------------\n'))
    cat(sprintf("%s\n", cmd))

    if (!debug) {
        str_message <- system(cmd, intern = TRUE)
        cat(str_message, sep = "\n")
        if (schedule == "ONCE") task_runnow(taskname)
    }
}
