test_that("timestamp works", {
    expect_equal(nchar(timestamp()), 13)
    expect_equal(nchar(datestamp()), 13)

    x = timestamp()
    date = millisec2date(x)
    expect_true(is.Date(date))
})
