header <- "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/83.0.4103.61 Safari/537.36"

#' @import httr
init_httr <- function() {
    set_config(c(
        # verbose(),
        timeout(60),
        add_headers(
            Connection = "keep-alive",
            `Accept-Encoding` = "gzip, deflate, br",
            `Accept-Language` = "zh-CN,zh;q=0.8,en;q=0.6",
            # Host = "modis.ornl.gov",
            # Origin = "https://modis.ornl.gov",
            # Referer = url,
            # `Upgrade-Insecure-Requests` = 1,
            `User-Agent` = header
        )
    ))
}
# handle_reset("https://modis.ornl.gov") #quite important
# Sys.setlocale("LC_TIME", "english")#
