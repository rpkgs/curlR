OS = .Platform$OS.type
# switch(OS, windows, unix)

#' init_selenium
#'
#' @param browserName firefox or chrome
#' 
#' @examples
#' # init_selenium(6666)
#' # kill_selenium(6666)
#' @import glue
#' @importFrom RSelenium remoteDriver
#' @export
init_selenium <- function(port = 4444, browserName = "firefox") {
    # java -jar selenium-server-standalone-3.141.59.jar -port 4444
    selenium <- system.file("bin/selenium-server-standalone-3.141.59.jar", package = "curlR")
    dir <- dirname(selenium)
    if (browserName == "firefox") {
        prefix = "gecko"
    } else if (browserName == "chrome") {
        prefix = "chrome"
    }
    
    # chrome or gecko
    if (OS == "windows") {
        driver <- system.file(glue("bin/{prefix}driver.exe"), package = "curlR")
    } else {
        driver <- system.file(glue("bin/{prefix}driver"), package = "curlR")
    }
    
    cmd <- glue("java -Dwebdriver.{prefix}.driver={driver} -jar {selenium} -port {port}")
    print(cmd)
    system(cmd, wait = FALSE)
    Sys.sleep(1)
    
    p <- RSelenium::remoteDriver("localhost", port = port, browserName = browserName)
    p$open()
    # p$maxWindowSize()
    p
}

#' @export
#' @rdname init_selenium
kill_selenium <- function(port = 4444){
    pid <- getPidByPort(port)
    if (length(pid) == 0) {
        message(glue("[ok] no corresponding PID"))
        return()
    }

    if (OS == "windows") {
        # system("taskkill /IM selenium-server -f")
        # system("taskkill /IM selenium-server -f")
        # system('taskkill /fi "imagename eq java.exe" -f')
        system(glue('tasklist /FI "PID eq {pid}"'))
        system(glue('taskkill /FI "PID eq {pid}" -f'))
    } else if (OS == "unix"){
        # cmd = "pkill -f R"
        cmd = glue("kill -9 {pid}")
        print(cmd)
        system(cmd)
    }
    invisible()
}

#' @export
getPidByPort <- function(port = 4444) {
    # lsof -i -P -n | grep LISTEN | grep 4444
    OS = .Platform$OS.type
    pid = suppressWarnings({
        if (OS == "windows") {
            r = shell(glue("netstat -a -n -o | grep {port} | grep LISTEN"), intern = TRUE)
            str_extract(r, "(?<=LISTENING\\s{1,20})\\d{1,}") %>% unique()
        } else {
            cmd = glue('netstat -tulpn | grep "{port} " | grep LISTEN')
            print(cmd)
            r = system(cmd, intern = TRUE, ignore.stderr = TRUE)
            str_extract(r, "(?<=LISTEN\\s{1,20})\\d{1,}") %>% unique()
        }
    })
    as.numeric(pid)
}
