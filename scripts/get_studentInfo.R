#! /usr/bin/Rscript
library(RSelenium)
library(seleniumPipes)
library(foreach)
library(iterators)
library(purrr)
library(dplyr)
library(glue)
library(jsonlite)
library(stringr)

# "java -jar selenium-server-standalone-3.141.59.jar"
devtools::load_all()
prefs = list('permissions.default.image', 2L)
cprof <- list(firefox_profile = list(prefs = prefs))

# user <- list(name = "15521041645", pwd = "dong1234")
# user <- list(name = "410621198505034044", pwd = "123456")

# write_json(user, "wk_user.json")
# user <- read_json("wk_user.json")

p <- remoteDriver(
    "localhost",
    port = 4444,
    # port = 6666,
    browserName = "firefox")
p$open() #p$maxWindowSize()
# wk_login(user$name[[1]], user$pwd[[1]])
# wk_listener(skip_finished = FALSE)
{
    url_login <- "http://xyfw.cug.edu.cn/tp_up/view?m=up#act=portal/viewhome"
    p$navigate(url_login)

    xml_find_first(p, "//*[@id='un']") %>% send_keys("049151")
    xml_find_first(p, "//*[@id='pd']") %>% send_keys("dong1234")

    code <- readline(prompt="请输入验证码: ")
    xml_find_first(p, "//*[@id='code']") %>% send_keys(code)
}

cookie <- p$getAllCookies()


p$navigate(sprintf("http://202.114.207.126/jwglxt/xtgl/index_initMenu.html?jsdm=&_t=%s", timestamp()))
p$navigate("http://202.114.207.126/jwglxt/xsxkjk/xsxkcx_cxXsxkIndex.html?gnmkdm=N255005&layout=default&su=049151")


x = xml_find_first(p, "//*[@class='ui-state-default jqgrid-rownum']")
clickElement(x)

xs = xml_find_all(p, '//a[@class="clj"]')
ids = sapply(xs, xml_text)

foreach(id = ids) %do% {
    url = glue("http://202.114.207.126/jwglxt/xtgl/photo_cxXszp.html?xh_id={id}&zplx=rxhzp")
    outfile = glue("images/{id}.png")
    download(url, outfile)
}


p$navigate(url)
p$getAllCookies()
