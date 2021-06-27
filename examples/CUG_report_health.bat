@echo off

taskkill /IM chromedriver.exe -f
taskkill /IM selenium-server -f
@REM taskkill /IM chromedriver.exe -f

Rscript CUG_report_health.R
pause
