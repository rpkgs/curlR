# https://stackoverflow.com/questions/17157721/how-to-get-a-docker-containers-ip-address-from-the-host
# docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' 1709
library(RSelenium)
library(seleniumPipes)
library(foreach)
library(iterators)
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
url_root <- "http://data.cma.cn/dataService/cdcindex/datacode/SURF_CLI_CHN_TEM_DAY_GRID_0.5/show_value/normal.html"

# userName <- "991810576@qq.com"
# userName <- ""

# MAIN scripts ------------------------------------------------------------
p$open(); p$maxWindowSize()
p$navigate(url_root)
login_cma(p, userName, password)
p$navigate(url_root)


for (year in seq(2011, 2012)) {
    fprintf("running %s\n", year)
    searchData(p, year)
    # Sys.sleep(1)
    # if (!p$getStatus()$ready){
    #     Sys.sleep(10)
    # }
    p$closeWindow()
    focus_first_window(p)
}

# p$execute_script('arguments[0].value = "2017-01-01";', args = list(txt_dateE))
