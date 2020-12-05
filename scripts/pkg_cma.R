#' @export
login_cma <- function(p, userName, password){
    r <- xml_find_first(p, "//*[@id='loginWeb']") %>% clickElement()
    xml_find_first(p, "//*[@id='userName']") %>% send_keys(userName)
    xml_find_first(p, "//*[@id='passwordFoot']") %>% send_keys(password)
    xml_find_first(p, "//*[@id='password']") %>% send_keys(password)
    xml_find_first(p, "//*[@id='verifyCode']") %>% send_keys("16ea")
    # x <- xml_find_first(p, "//*[@id='login']") %>% clickElement()
}

#' @export
searchDataByYear <- function(p, year){
    # on.exit(focus_first_window(p))
    date_start <- sprintf("%d-01-01", year) %>% ymd()
    searchDataByMonth(p, date_start, 12)
}


#' searchDataByMonth
#'
#' @param date date obj
#' @param delta in unit of month
#'
#' @export
searchDataByMonth <- function(p, date_start, delta = 20){
    # on.exit(focus_first_window(p))

    txt_dateS = getElementById(p, "dateS")
    txt_dateE = getElementById(p, "dateE")

    date_end <- add_month(date_start, delta) - ddays(1)

    set_text(txt_dateS, format(date_start))
    set_text(txt_dateE, format(date_end))

    # 1. search
    xml_find_first(p, "search-bt1210", "class") %>% clickElement() # submit
    focus_last_window(p)

    times <- 1
    Sys.sleep(3)
    while(!p$getStatus()$ready) {
        if (times > 10) break

        print(times)
        times <- times + 1
        Sys.sleep(6)
    }
    # 2. add to car
    xml_find_first(p, "buttonAddCar", "id") %>% clickElement()
}
