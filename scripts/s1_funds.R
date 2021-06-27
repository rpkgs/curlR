# source('main_pkgs.R')
library(lubridate)
library(curlR)
library(ChinaWater)
library(plyr)

port <- 4445
kill_selenium(port)
p <- init_selenium(port)

p$navigate("https://fund.sciencenet.cn/")
url = p$getCurrentUrl()[[1]]

get_pageInfo <- function() {
    pages <- xml_find_all(p, "//span[@class='btn']/a")
    page_num = xml_text(pages) %>% as.numeric()
    urls <- pages %>% xml_attr("href") #%>% unique()
    info = data.table(page_num, urls) %>% unique() %>%
        .[-nrow(.), ]
    info
}

d1 <- get_pageInfo()
d2 <- get_pageInfo()
df <- rbind(d1, d2) %>%
    .[!is.na(page_num), ] %>%
    .[order(page_num), ] %>%
    .[!duplicated(page_num), ]
# p %>% xml_find_all("//body")
# p %>% getElementById("resultLst")

get_data <- function(url = NULL) {
    if (!is.null(url)) p$navigate(url)
    xs = p$getPageSource()[[1]] %>% read_html() %>%
        xml2::xml_find_all("//div[@id='resultLst']/div")
    # x = d[[1]]
    # xml2::xml_find_all(x, "div") #%>% xml_text() %>% str_extract("[\u4e00-\u9fa5]{1,}")
    rm_empty_str <- function(x) x[x != ""]
    res = lapply(xs, function(x) {
        title = xml2::xml_find_all(x, "p") %>% xml_text() %>% str_extract("[\u4e00-\u9fa5]{1,}")
        info = xml2::xml_find_all(x, "div") %>% xml_text() %>% gsub(" ", "", .) %>%
            {str_split(., "\n")[[1]]} %>%
            gsub("研究类型：|负责人：|申请单位：|批准年度：|金额：|关键词：", "", .) %>%
            rm_empty_str() %>%
            c(title, .)
        info
    })
    Sys.sleep(3)
    do.call(rbind, res) %>% data.table()
}

res = llply(df$urls[-(1:13)], get_data)

d = res %>% rm_empty() %>% do.call(rbind, .)
colnames(d) <- c("title", "name", "unit", "type", "id", "year", "fund", "keyword")
write_list2xlsx(d, "专家3.xlsx")
