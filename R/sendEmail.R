.config <- list2env(list(python = FALSE))
fileConfig <- normalizePath("~/.R/curlR.json") # system.file("~/config.json", package = "curlR")

#' send email by email and smtplib
#'
#' Please fill the configuration information first by the [EmailConfig_qq()].
#' Config once, and user configuration will be stored.
#' 
#' @param receiver the email address of the receiver
#' @param title,content the mail title and content
#' 
#' @note currently only QQ email supported. But it is easy to extend more.
#' 
#' @examples
#' \dontrun{
#' EmailConfig_qq("991810576@qq.com", "XXXXXXXX")
#' sendEmail("kongdd@mail2.sysu.edu.cn", content = "hello python email")
#' }
#' @export
sendEmail <- function(receiver = "kongdd@mail2.sysu.edu.cn", content = "", title = "curlR") {
    file <- system.file("python/sendEmail.py", package = "curlR")
    reticulate::source_python(file)

    # if (file.exists(Sys.getenv("RETICULATE_PYTHON")) && !.config$python) {
    #     # init_python()
    #     .config$python = TRUE
    # }
    sendEmail_py(receiver, title, content, fileConfig = fileConfig)
}

#' set the email information of the email sender
#' 
#' Configuration will be write to `curlR/python/config.json`, where user, PassCode 
#' and server will be stored.
#' 
#' @param user the email address of the sender
#' @param PassCode the pass code of the sender, the length is 16 for QQ `PassCode`
#' 
#' @examples 
#' \dontrun{
#' EmailConfig_qq("991810576@qq.com", "XXXXXXXX")
#' }
#' @export 
EmailConfig_qq <- function(user, PassCode) {
    # fileConfig = system.file(package = "curlR") %>% paste0("/config/config.json")
    check_dir(dirname(fileConfig))

    config = listk(user, PassCode, "server" =  "smtp.qq.com")
    jsonlite::write_json(config, fileConfig, pretty = TRUE)
}
