get_asks <- function(question_types, range) {
    rows <- length(k$open_notes)
    displays <- paste0("all_", range)

    question_types %>%
        map(
            function(type) {
                if (type == "note_name") {
                    # Get random row (and open note)
                    row <- sample(rows, 1)
                    open_note <- k$open_notes[row]

                    # Get random column (and fret, note)
                    display <- sample(displays, 1)
                    notes <- string_notes(open_note, display)
                    columns <- which(notes != "")
                    column <- sample(columns, 1)
                    fret <- glue("fret{column-1}")
                    note <- notes[column]

                    data.table(
                        type = type,
                        row = row,
                        open_note = open_note,
                        column = column,
                        fret = fret,
                        note = note
                    )
                }
            }
        ) %>%
        rbindlist()
}


df <- data.table(
    a = sample(1:2, 4, replace = TRUE),
    b = sample(1:2, 4, replace = TRUE)
)
