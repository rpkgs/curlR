get_time <- function(divs) {
  sapply(divs, function(x) {
    xml_text(x) %>% str_extract("\\d{2}:\\d{2}")
  })
}

min_str2num <- function(x) {
  min = str_extract(x, "\\d{2}(?=:)") %>% as.numeric()
  sec = str_extract(x, "(?<=:)\\d{2}") %>% as.numeric()
  min*60 + sec
}


wk_login <- function(userName, password) {
  url_login <- "http://hubeigs.zymreal.com/resource/index#/study/list"
  p$navigate(url_login)

  xml_find_first(p, "//*[@id='username']") %>% send_keys(userName)
  xml_find_first(p, "//*[@id='password']") %>% send_keys(password)
  xml_find_first(p, "//*[@class='btn_login']") %>% clickElement()
}

video_info <- function(p) {
  video = xml_find_first(p, "//video")
  duration = p$executeScript("return arguments[0].duration;", list(video))[[1]] %>% as.numeric()
  currentTime = p$executeScript("return arguments[0].currentTime;", list(video))[[1]] %>% as.numeric()
  time_left = duration - currentTime
  list(time_len = duration, time_cur = currentTime, time_left = time_left)
}

#' wk_course
#' @param time_wait second, waiting second of video info
#' @export
wk_course <- function(str_course, time_wait = 10, skip_finished = TRUE) {
  p$navigate(str_course)
  Sys.sleep(2)
  # status = xml_find_all(p, "//div[@class='handle']/i")
  # divs <- xml_find_all(p, "//*[@class='res-item resource active']")
  # str_mins <- get_time(divs)
  # secs <- min_str2num(str_mins)

  # divs <- xml_find_all(p, "//*[@class='res-item resource active']")
  # browser()
  sections = xml_find_all(p, "//*[@class='title section-name']")
  temp <- sapply(sections, function(x) x %>% clickElement())
  items = xml_find_all(p, "//li[@id]") # lessions

  status = xml_find_all(p, "//li/i[2]")
  is_finished = status %>% xml_html(parse = FALSE) %>% grepl("finish", .)
  n <- length(is_finished)

  for (i in 1:n) {
    if (skip_finished && is_finished[i]) next()
    # divs <- xml_find_all(p, "//*[@class='res-item resource']")
    # print(length(divs))
    # tryCatch({
      # browser()
      title = items[[i]] %>% xml_html() %>% xml_attr("title")
      # title <- items[[i]] %>% xml_text()
      items[[i]] %>% clickElement()
      Sys.sleep(time_wait)

      info = video_info(p)
      cat(sprintf("[%02d] %s, %.0fs / %.0fs\n", i, title, info$time_cur, info$time_len))
      Sys.sleep(info$time_left)
    # }, error = function(e) {
    #   message(sprintf('%s', e$message))
    # })
  }
}

#' @export
wk_listener <- function(skip_finished = TRUE) {
  for (i in 1:10) {
    courseIds <- 222:237
    for (courseId in courseIds) {
      tryCatch({
        url <- glue("http://hubeigs.zymreal.com/resource/index#/study/learn/{courseId}")
        # url = glue("http://hubeigs.zymreal.com/resource/index#/study/course/{courseId}")
        p$navigate(url)
        wk_course(url, skip_finished = skip_finished)
      }, error = function(e) {
        message(sprintf("%s", e$message))
      })
    }
  }
}
