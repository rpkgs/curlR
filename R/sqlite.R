#' @export 
is_processed <- function(con, time) {
    if (!("SQLiteConnection" %in% class(con)) && is.character(con)) {
        con <- dbConnect(dbDriver("SQLite"), dbname = con)
        on.exit(dbDisconnect(con))
    }
    if (!is.character(time)) time <- time2str(time)

    tryCatch(
        {
            rs <- dbSendQuery(con, glue("SELECT * FROM timeinfo WHERE time = '{time}'"))
            on.exit(dbClearResult(rs))
            nrow(dbFetch(rs)) > 0
        },
        error = function(e) {
            message(sprintf("%s", e$message))
            FALSE
        }
    )
}

#' @export
db_sqlite <- function(dbname) {
    dbConnect(dbDriver("SQLite"), dbname)
}

read_csv <- function(file) {
    timeinfo <- guess_time(file) %>% timeinfo()
    cbind(timeinfo[, .(time, timenum)], fread(file))
}

db_merge <- function(db1, db2) {
    l1 <- db_read(db1)
    l2 <- db_read(db2)
}

#' @export
list2db <- function(lst, con, overwrite = TRUE) {
    append <- !overwrite
    if (is.character(con)) {
        con <- db_sqlite(con)
        on.exit(dbDisconnect(con))
    }

    names <- names(lst)
    for (i in seq_along(lst)) {
        dbWriteTable(con, names[i], lst[[i]], overwrite = overwrite, append = append)
    }
}
