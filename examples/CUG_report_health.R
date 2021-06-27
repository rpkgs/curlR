library(curlR)
print(Sys.time())

## 成功登陆地大信息门户
login_CUG <- function(){
    # 通过QQ登陆
    p$navigate("http://xyfw.cug.edu.cn/tp_up/view?m=up#act=portal/viewhome")
    x = p$findElement("css selector", ".qq") %>% clickElement()
    p$switchToFrame(0)
    p$findElement("xpath", "//span[4]") %>% clickElement()
}

report_health <- function(){
    tryCatch({
        p$navigate("http://rsfw.cug.edu.cn/rsfw/sys/lwReportEpidemic/*default/index.do#/")
        Sys.sleep(5)
        p$findElement("css selector", ".geuhjrnk") %>% clickElement()
        Sys.sleep(3)

        p$findElement("css selector", "div.OPjctwlgzsl button.mt-btn-primary") %>% clickElement()
        Sys.sleep(3)

        p$findElement("css selector", "button.mint-msgbox-confirm") %>% clickElement() # confirm
    }, error = function(e) {
        message(sprintf("%s", e$message))
        Sys.sleep(5)
        cat(sprintf(("[ok] 已经申报。\n")))
    })
}

{
    port <- 4445
    kill_selenium(port)
    p <- init_selenium(port, browserName = "chrome")

    login_CUG()
    Sys.sleep(5)
    report_health()

    p$closeall()
}

# kill_selenium(port)
# system("taskkill /IM chromedriver.exe -f")
# system("taskkill /IM chromedriver.exe -f")
# system("taskkill /IM selenium-server -f")

if (0) {
    # create daily task in windows
    infile = "E:/Research/cluster/curlR/examples/CUG_report_health.R" # change to your path
    task_create(
        taskname = "CUG_ReportHealth", rscript = infile,
        schedule = "DAILY", starttime = "07:10"
    )
    task_ls("CUG_ReportHealth")
}
