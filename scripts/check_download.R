library(tidyverse)
library(stringr)
library(magrittr)
library(lubridate)

indir <- "F:/文档任务组_20190613_2022/temp_daily_0.5deg/"
files <- dir(indir, "*.txt$", full.names = TRUE)
files2 <- dir("D:/Documents/Tencent Files/991810576/FileRecv/中国日气温数据（1961-2015年_0.5）", "*.txt", full.names = TRUE)
info2 <- match2(basename(files), basename(files2))
info2

s <- files2[-info2$I_y] %>% file.rename(., paste0(indir, basename(.)))

dates <- basename(files) %>% str_extract("\\d{8}") %>% ymd() %>% unique() %>% sort()
info  <- zip_dates(dates)

lst   <- files %>% split(str_extract(., "(?<=\\d-).*(?=-\\d)"))

read_txt <- function(file){
    mat <- fread(file, skip = 6) %>% as.matrix() %>% as.numeric()
    mat
}

microbenchmark::microbenchmark(
    sp <- rgdal::readGDAL(file) ,
    mat <- fread(file, skip = 6),
    times = 2
)
spplot(sp)

# d <- data.frame(x = )
# d[d == -99] <- NA
x <- as.numeric(t(as.matrix(mat)))
x[x == -99] <- NA
sp$band2 <- x
# sp@data <- d
spplot(sp)

file1 <- "F:/文档任务组_20190613_2022/temp_daily_0.5deg/SURF_CLI_CHN_TEM_DAY_GRID_0.5-MAX-19610101.txt"
file0 <- "D:/Documents/Tencent Files/991810576/FileRecv/中国日气温数据（1961-2015年_0.5）/SURF_CLI_CHN_TEM_DAY_GRID_0.5-MAX-19610101.txt"

x1 <- read_txt(file1)
x0 <- read_txt(file0)

x <- rgdal::readGDAL(file)@data
