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

user <- list(name = "15521041645", pwd = "dong1234")
# user <- list(name = "410621198505034044", pwd = "123456")

# write_json(user, "wk_user.json")
# user <- read_json("wk_user.json")

p <- remoteDriver(
    "localhost",
    port = 4444,
    # port = 6666,
    browserName = "firefox")
p$open(); #p$maxWindowSize()
wk_login(user$name[[1]], user$pwd[[1]])
wk_listener(skip_finished = FALSE)
