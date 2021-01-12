#' init_selenium
#' 
#' @examples 
#' # init_selenium(6666)
#' # kill_selenium(6666)
#' @import glue
#' @importFrom RSelenium remoteDriver
#' @export 
init_selenium <- function(port = 4444) {
    # java -jar selenium-server-standalone-3.141.59.jar -port 4444
    bin <- system.file("bin/selenium-server-standalone-3.141.59.jar", package = "curlR")
    dir <- dirname(bin)
    cmd <- glue("cd {dir} && java -jar {bin} -port {port}")
    shell(cmd, wait = FALSE)

    p <- remoteDriver(
        "localhost",
        port = port,
        browserName = "firefox"
    )
    p$open()
    p$maxWindowSize()
    p
}

#' @export
#' @rdname init_selenium
kill_selenium <- function(port = 4444){
    os = .Platform$OS.type
    if (os == "windows") {
        # system("taskkill /IM selenium-server -f")
        # system("taskkill /IM selenium-server -f")
        # system('taskkill /fi "imagename eq java.exe" -f')
        pid <- getPidByPort(port)
        if (is.na(pid)) {
            message(glue("[ok] no corresponding PID"))
            return()
        }
        
        system(glue('tasklist /FI "PID eq {pid}"'))
        system(glue('taskkill /FI "PID eq {pid}" -f'))
    } else if (os == "unix"){
        system("pkill -f R")
        # NULL
    }
    invisible()
}

#' @export
getPidByPort <- function(port = 4444) {
    res = suppressWarnings({
        shell(glue("netstat -a -n -o | grep {port} |  grep LISTENING"), intern = TRUE)
    }) 
    if (length(res) > 0) {
        str_extract(res, "(?<=LISTENING\\s{1,20})\\d{1,}") %>% unique()
    } else {
        NA
    }
}
