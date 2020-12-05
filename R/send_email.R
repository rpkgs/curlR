#' send email by email and smtplib
#' 
#' @export 
send_email <- function(receiver = "kongdd@mail2.sysu.edu.cn", title = "ChinaWater", content = "") {
    sendEmail(receiver, title, content)
}
