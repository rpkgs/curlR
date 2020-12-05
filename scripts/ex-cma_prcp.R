# https://stackoverflow.com/questions/17157721/how-to-get-a-docker-containers-ip-address-from-the-host
# docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' 1709
library(RSelenium)
library(seleniumPipes)
library(foreach)
library(iterators)
library(purrr)
library(dplyr)

# version <- "75.0.3770.80"
# prefs = list("profile.managed_default_content_settings.images" = 2L)
prefs = list('permissions.default.image', 2L)
cprof <- list(firefox_profile = list(prefs = prefs))

p <- remoteDriver(
    "localhost",
    port = 4444,
    browserName = "firefox"
)

# remoteServerAddr = "192.168.1.107",
# extraCapabilities = cprof
# version = "75.0.3770.80"

# p$findElement("id", "user_target")
url_root <- "http://data.cma.cn"
url_root <- "http://data.cma.cn/dataService/cdcindex/datacode/SURF_CLI_CHN_PRE_DAY_GRID_0.5/show_value/normal.html"

userName <- "991810576@qq.com"
# userName <- ""

userName <- "1154518030@qq.com"
password <- ""

# MAIN scripts ------------------------------------------------------------
p$open(); p$maxWindowSize()
p$navigate(url_root)
login_cma(p, userName, password)
p$navigate(url_root)

# years <- c(2010, 2014, 2015, 2016, 2017, 2018, 2019)[(1:4)]
# years <- 1961:2000
dates = seq_month(ymd("1961-01-01"), ymd("2019-08-31"), 20)

# i = 0
for (i in 1:length(dates)) {
    date_start <- dates[i]
    fprintf("[%02d] running %s\n", i, year(date_start))

    searchDataByMonth(p, date_start, 20)

    if (!p$getStatus()$ready){
        Sys.sleep(10)
    }
    p$closeWindow()
    focus_first_window(p)
    p$navigate(url_root)

    # if (year != last(years))
    Sys.sleep(5)
}

# p$execute_script('arguments[0].value = "2017-01-01";', args = list(txt_dateE))
