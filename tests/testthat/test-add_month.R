test_that("date works", {
    expect_equal(add_month(as.Date("2020-09-01"), 4), as.Date("2021-01-01"))

    dates = seq_month(as.Date("2019-01-01"), as.Date("2020-12-01"), 3)
    expect_equal(length(dates), 8)

    timestr = format_POSIXt(dates[1])
    expect_equal(nchar(timestr), 19)
})
