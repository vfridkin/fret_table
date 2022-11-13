#' Get a vector of notes for a string
#' @param start_note first note letter on the string
#' @param display string with form {name}_{accidental} - see examples
#' @param fretcount number of frets
#' @examples
#' string_notes(display = "allplus_sharp")
#' string_notes(display = "all_flat")
#' string_notes(display = "e_natural")
#' string_notes(display = "fret3_flat")
#'
string_notes <- function(start_note = "E",
                         display = "",
                         fret_count = k$fret_count) {
    # Guard nothing to display
    nothing_to_display <- any(
        is.null(display), display == ""
    )
    if (nothing_to_display) {
        return(rep("", fret_count + 1))
    }

    # Get all notes for string
    note_filter <- display %>%
        strsplit(display, split = "_") %>%
        pluck(1) %>%
        set_names(c("name", "accidental")) %>%
        as.list()

    # Show sharps by default
    is_flat <- note_filter$accidental == "flat"
    fn <- iff(is_flat, tail, head)

    # Get all notes
    notes <- 0:fret_count %>%
        map(~ next_note(start_note, .x)) %>%
        map_chr(fn, 1)

    # Gaurd plus (naturals plus accidental)
    if (note_filter$name == "allplus") {
        return(notes)
    }

    # Guard specific fret
    is_fret <- str_detect(note_filter$name, "fret")
    if (is_fret) {
        fret <- note_filter$name %>%
            str_replace("fret", "") %>%
            as.integer()
        notes <- 0:fret_count %>% map_chr(
            ~ iff(.x == fret, notes[.x + 1], "")
        )
        return(notes)
    }

    # Apply note filter to naturals vs accidentals
    char_count <- iff(note_filter$accidental == "natural", 1, 2)

    notes <- notes %>% map_chr(
        ~ iff(nchar(.x) == char_count, .x, "")
    )

    # Guard all
    if (note_filter$name == "all") {
        return(notes)
    }

    notes <- notes %>% map_chr(
        ~ iff(tolower(substr(.x, 1, 1)) == tolower(note_filter$name), .x, "")
    )

    notes
}


# Get the next note from a given note, using +, - for accidentals
next_note <- function(note = "E", interval = 1) {
    if (interval == 0) {
        return(note)
    }
    notes <- k$notes
    note_count <- length(notes)

    this_note <- list(
        name = substr(note, 1, 1),
        accidental = substr(note, 2, 2)
    )

    note_position <- which(this_note$name == notes)[[1]]

    has_accidental <- this_note$accidental != ""
    if (has_accidental) {
        delta_position <- iff(this_note$accidental == "+", 1, -1)
        note_position <- note_position + delta_position
    }

    next_position <- (note_position + interval - 1) %% note_count %>% "+"(1)

    new_note <- notes[next_position]

    # If new note is 'x' then return sharp and flat form
    if (new_note == "x") {
        new_note <- c(
            paste0(notes[next_position - 1], "+"),
            paste0(notes[next_position + 1], "-")
        )
    }

    new_note
}

as_note_text <- function(note) {
    note %>%
        str_replace("\\+", "♯") %>%
        str_replace("\\-", "♭")
}

as_note_html <- function(note) {
    this_note <- list(
        name = substr(note, 1, 1),
        accidental = substr(note, 2, 2)
    )

    # Guard empty notes
    if (this_note$name == "") {
        return("")
    }

    is_accidental <- this_note$accidental != ""
    note_text <- note %>% as_note_text()

    fn <- function(is_accidental_colour, is_not_accidental_colour) {
        iff(
            is_accidental,
            k$colour[[is_accidental_colour]],
            k$colour[[is_not_accidental_colour]]
        )
    }
    gradient_colour <- fn("accidental", "natural")
    gradient_edge_colour <- fn("accidental_lighter", "natural_darker")
    dot_text_colour <- fn("natural", "accidental")

    style <- paste0(
        "--gradient: ", gradient_colour, ";
            --gradient-edge: ", gradient_edge_colour, ";
            --dot-text: ", dot_text_colour, ";
            --dot-visible: visible;
            "
    )

    glue("
        <div class='dot-container'>
            <span class='dot' style ='{style}'>
              <span class='dot-text'>
                {note_text}
              </span>
            </span>
        </div>
    ")
}

as_note_html_v <- Vectorize(as_note_html)
