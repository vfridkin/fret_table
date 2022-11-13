get_questions <- function(game, range, turns) {
    rows <- length(k$open_notes)
    displays <- paste0("all_", range)
    question_types <- sample(game, turns, replace = TRUE)

    # Take double the number of questions to minimise chance of repeats
    df <- rep(question_types, 2) %>%
        map(
            function(type) {
                # Get random row (and open note)
                row <- sample(rows, 1)
                open_note <- k$open_notes[row]

                # Get random column (and fret, note)
                display <- sample(displays, 1)
                notes <- string_notes(open_note, display)
                columns <- which(notes != "")
                column <- sample(columns, 1)
                fret <- glue("fret{column-1}") %>% as.character()
                note <- notes[column]

                # When choosing fret only keep the note
                if (type == "note_fret") {
                    row <- 0L
                    column <- 0L
                    open_note <- ""
                    fret <- ""
                }

                df <- data.table(
                    type = type,
                    note = note,
                    row = row,
                    column = column,
                    open_note = open_note,
                    fret = fret
                )
            }
        ) %>%
        rbindlist()

    # Sort so that consecutive rows are different and take the top half
    cols <- names(df)
    df <- df[,
        .(type, note, row, column, open_note, fret, V2 = 1:.N),
        by = .(V1 = rleid(note, row, column))
    ][order(V2, V1), ..cols][, turn := .I] %>% head(turns)

    df
}
