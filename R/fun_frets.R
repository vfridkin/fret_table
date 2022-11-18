add_fret_markers <- function(df) {
    fn <- function(x) paste0("<span class='fret-marker'></span>", x)
    fn2 <- function(x) paste0("<span class='fret-marker2'></span>", x)

    cols <- paste0("fret", c(3, 5, 7, 9))

    # Markers are split between vertically adjacent divs

    # Top half of markers
    df[3, (cols) := lapply(.SD, fn), .SDcols = cols]
    df[c(2, 4), fret12 := fn(fret12)]

    # Bottom half of markers
    df[4, (cols) := lapply(.SD, fn2), .SDcols = cols]
    df[c(3, 5), fret12 := fn2(fret12)]

    df
}

#' Convert fret selection to display format
#' @param fret_select list(row = {row}, col = {col_name})
#' @return {name}_{accidental}
display_from_fret <- function(fret_select, accidental = "sharp") {
    name <- fret_select$col
    display <- iff(
        name == "none",
        "", glue("{name}_{accidental}")
    )

    list(
        rows = fret_select$row,
        display = display
    )
}

#' Column definitions for frets
get_fret_col_def <- function(fret_count) {
    headstock_coldef <- list(
        fret0 = colDef(
            name = "",
            class = function(value, index, name) {
                paste0("headstock-string fretcell string", index, " ", name)
            },
            style = function(value, index, name) {
                paste0(
                    "position: relative;
          --thickness: ", k$string_thickness[index], "px;
          --rotation: ", k$string_rotation[index], "deg;
          "
                )
            }
        )
    )

    fret_names <- paste0("fret", 1:k$fret_count)

    fret_min_width <- function(fret) {
        round(50 * (1 - fret / 24))
    }

    frets_coldef <- 1:k$fret_count %>%
        map(
            function(fret) {
                colDef(
                    name = "",
                    minWidth = fret_min_width(fret),
                    html = TRUE,
                    align = "center",
                    class = function(value, index, name) {
                        paste0("guitar-string fretcell string", index, " ", name)
                    },
                    style = function(value, index, name) {
                        paste0(
                            "position: relative; --thickness: ", k$string_thickness[index], "px;"
                        )
                    }
                )
            }
        ) %>%
        set_names(fret_names)

    c(headstock_coldef, frets_coldef)
}

# Visibility -------------------------------------------------------------------
dot_visibility <- function(session, visible, row = 0, fret = "") {
    change_all <- any(row == 0, fret == "")

    if (change_all) {
        session$sendCustomMessage(
            "dot_all_visibility",
            visible
        )
        return()
    }
}

note_visibility <- function(session,
                            visible,
                            string = "",
                            fret = "",
                            accidental = "sharp",
                            role = "display") {
    string_class <- iff(string == "", "", paste0(".", string))
    fret_class <- iff(fret == "", "", paste0(".", fret))

    coord_class <- paste0(string_class, fret_class)
    dot_colour <- k$colour[[role]]
    inject_text <- iff(role == "question", "?", "")

    session$sendCustomMessage(
        "note_visibility_by_coordinate",
        list(
            visible = visible,
            coord = coord_class,
            accidental = accidental,
            role = role,
            dot_colour = dot_colour,
            inject_text = inject_text
        )
    )
}

#' Remove all question notes - do this after each game
clear_questions <- function(session) {
    session$sendCustomMessage(
        "clear_questions", ""
    )
}

note_visibility_by_accidental <- function(session, visible, letter, accidental) {
    letter_class <- iff(
        letter != "", letter %>%
            tolower() %>%
            paste0("-note"),
        ""
    )
    session$sendCustomMessage(
        "note_visibility_by_accidental",
        list(
            visible = visible,
            letter = letter_class,
            accidental = accidental
        )
    )
}

#' Show fret notes from letter selection
#' @param display {name}_{accidental} - see examples
#' @examples
#' fret_visible_from_letter(display = "allplus_sharp")
#' fret_visible_from_letter(display = "all_flat")
#' fret_visible_from_letter(display = "e_natural")
#' fret_visible_from_letter(display = "f_sharp")
#'
fret_visible_from_letter <- function(session, display) {
    # Hide all highlights by default
    clear_questions(session)

    # Hide all dots by default
    dot_visibility(session, FALSE)

    # Guard nothing to display
    nothing_to_display <- any(
        is.null(display), display == ""
    )
    if (nothing_to_display) {
        return()
    }

    # Get notes to display
    note_filter <- display %>%
        strsplit(display, split = "_") %>%
        pluck(1) %>%
        set_names(c("name", "accidental")) %>%
        as.list()

    # Gaurd plus (all notes - naturals plus accidental)
    if (note_filter$name == "allplus") {
        # Show all naturals
        note_visibility_by_accidental(
            session,
            TRUE,
            "",
            "natural"
        )
        # Show all accidentals
        note_visibility_by_accidental(
            session,
            TRUE,
            "",
            note_filter$accidental
        )
        return()
    }

    # Gaurd all (all of a single accidental including natural)
    if (note_filter$name == "all") {
        # Show all accidentals
        note_visibility_by_accidental(
            session,
            TRUE,
            "",
            note_filter$accidental
        )
        return()
    }

    # Remainder is single letter
    note_visibility_by_accidental(
        session,
        TRUE,
        note_filter$name,
        note_filter$accidental
    )
}


#' Show note on fret from string/fret selection
#' @param display string and fret coordinates
#' @param accidental sharp or flat (if natural at coord then ignored)
#' @param role one of: display (default), question, right, wrong
#' When learning, role = display
#' When playing, role = question (hides the note text), then right/wrong
#' depending on the answer
#' @return side effect - note shows on fretboard
fret_visible_from_fretboard <- function(session,
                                        display,
                                        accidental,
                                        role = "display") {
    # Hide all dots and questions
    dot_visibility(session, FALSE)
    clear_questions(session)

    # Guard nothing to display
    nothing_to_display <- any(
        is.null(display),
        all(
            display$string == "none",
            display$fret == "none"
        )
    )
    if (nothing_to_display) {
        return()
    }

    # Remainder is single letter
    note_visibility(
        session,
        TRUE,
        string = display$string,
        fret = display$fret,
        accidental = accidental,
        role = role
    )
}

show_game_results <- function(session, log) {
    # Seperate true and false answers into columns
    wide_log <- log[, .(row, column, correct)] %>%
        dcast(
            row + column ~ correct,
            fun.aggregate = length
        )
    names(wide_log) %<>% tolower()

    1:nrow(wide_log) %>% walk(
        ~ wide_log[.x] %>%
            add_result_to_fret(session)
    )
}

clear_game_results <- function(session) {
    session$sendCustomMessage("clear_game_results", "")
}

add_result_to_fret <- function(result, session) {
    string_class <- paste0(".string", result$row)
    fret_class <- paste0(".fret", result$column - 1)

    coord_class <- paste0(string_class, fret_class)

    # Compile html to inject into coordinate
    inject <- ""
    has_true <- all(!is.null(result$true), result$true > 0)
    if (has_true) {
        num <- iff(result$true == 1, "", result$true)
        val <- get_answer_html("TRUE", k$colour$right, num)
        inject <- paste0(inject, val)
    }

    has_false <- all(!is.null(result$false), result$false > 0)
    if (has_false) {
        num <- iff(result$false == 1, "", result$false)
        val <- get_answer_html("FALSE", k$colour$wrong, num)
        inject <- paste0(inject, val)
    }

    inject_html <- glue("
        <span class='result-note'>
            {inject}
        </span>")

    # Send html to coordinate on fretboard
    session$sendCustomMessage(
        "add_result_to_fret",
        list(
            coord = coord_class,
            inject_html = inject_html
        )
    )
}
