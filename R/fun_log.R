make_log_row <- function(question, response, source, start_time, play_time) {
    log_row <- question[, .(type, note, row, column)]
    play_time <- play_time %>%
        as.numeric() %>%
        round(2)

    # Convert to log type
    log_row[, type := ac$game[id == type]$log_id]

    if (source == "letter") {
        log_row[, correct := question$note == response]
    }

    log_row[, start_time := start_time]
    log_row[, play_time := play_time]

    log_row
}

create_new_log <- function() {
    data.table(
        type = 0L,
        note = "X",
        row = 0L,
        column = 0L,
        correct = FALSE,
        start_time = Sys.time(),
        play_time = 0.0
    )
}

save_log <- function(session, data) {
    set_local_storage("log", data, session)
}

load_saved_log <- function(session) {
    log <- get_local_storage("log", session)
    no_log <- is.null(log)

    # If log doesn't exist, create a new one
    if (no_log) {
        log <- create_new_log()
    }

    log
}
