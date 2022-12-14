make_log_row <- function(question, response, source, start_time, play_time) {
    log_row <- question[, .(type, note, row, column)]
    play_time <- play_time %>%
        as.numeric() %>%
        round(2)

    # Convert to log type
    log_row[, type := ac$game[id == type]$log_id]

    fn <- iff(source == "letter", include_enharmonics, fret_to_note)
    response_note <- response %>% fn()

    # Add coordinates if clicking on the fret
    if (source == "fret") {
        log_row$row <- response$row
        log_row$column <- response$fret %>%
            str_replace("fret", "") %>%
            as.integer() %>%
            "+"(1)
    }

    log_row[, correct := (question$note %in% response_note)]
    log_row[, start_time := start_time]
    log_row[, play_time := play_time]

    log_row
}



create_new_log <- function() {
    df <- data.table(
        type = 0L,
        note = "X",
        row = 0L,
        column = 0L,
        correct = FALSE,
        start_time = Sys.time(),
        play_time = 0.0
    )

    df[0]
}

save_log <- function(session, data) {
    set_local_storage("log", data, session)
}

load_saved_log <- function(session) {
    get_local_storage("log", session)
}
