# source('main_pkgs.R')
library(lubridate)
library(curlR)
library(ChinaWater)
library(plyr)

port <- 4445
kill_selenium(port)
p <- init_selenium(port)


## 成功登陆地大信息门户
p$navigate("http://xyfw.cug.edu.cn/tp_up/view?m=up#act=portal/viewhome")
x = p$findElement("css selector", ".qq") %>% clickElement()
p$switchToFrame(0)
p$findElement("xpath", "//span[4]") %>% clickElement()

