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

#' Get a vector of notes for a string with accidentals joined by pipe '|'
#' @param start_note first note letter on the string
#' @param fretcount number of frets
string_notes_with_joined_accidentals <- function(start_note = "E",
                                                 fret_count = k$fret_count) {
    # Get all notes
    notes <- 0:fret_count %>%
        map(~ next_note(start_note, .x)) %>%
        map_chr(~ paste(.x, collapse = "|"))


    notes
}


#' Get the next note from a given note, using p, q for accidentals
#' p: flat
#' q: sharp
#' @param note starting note
#' @param interval to next note
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
        delta_position <- iff(this_note$accidental == "q", 1, -1)
        note_position <- note_position + delta_position
    }

    next_position <- (note_position + interval - 1) %% note_count %>% "+"(1)

    new_note <- notes[next_position]

    # If new note is 'x' then return sharp and flat form
    if (new_note == "x") {
        new_note <- c(
            paste0(notes[next_position - 1], "q"),
            paste0(notes[next_position + 1], "p")
        )
    }

    new_note
}

as_note_text <- function(note) {
    note %>%
        str_replace("q", "???") %>%
        str_replace("p", "???")
}

letter_to_note <- function(letter) {
    split <- strsplit(letter, "_") %>% pluck(1)
    accidental <- split[2] %>%
        str_replace("flat", "p") %>%
        str_replace("sharp", "q") %>%
        str_replace("natural", "")

    note_name <- toupper(split[1])

    # Handle learning letters - have 'all' in their name
    is_learn_letter <- str_detect(note_name, "ALL")

    note <- iff(
        is_learn_letter,
        "learn",
        paste0(note_name, accidental)
    )

    note
}

fret_to_note <- function(coord) {
    valid <- all(
        !is.null(coord$row),
        !is.null(coord$fret)
    )

    if (!valid) {
        return(NULL)
    }

    open_note <- k$open_notes[coord$row]
    interval <- coord$fret %>%
        str_replace("fret", "") %>%
        as.integer()
    next_note(open_note, interval)
}


as_note_html <- function(note) {
    # Guard empty notes
    if (note == "") {
        return("")
    }

    is_accidental <- note %>% str_detect("\\|")
    note_split <- strsplit(note, " ") %>% pluck(1)
    note_value <- note_split[1]
    background_colour <- note_split[2]

    # Span to contain note name and classes
    note_span <- ""

    if (is_accidental) {
        notes <- note_value %>%
            as_note_text() %>%
            strsplit("\\|") %>%
            pluck(1)
        note_class <- notes %>%
            map_chr(~ substr(.x, 1, 1)) %>%
            tolower() %>%
            paste0("-note")
        note_span <- glue("
            <span class='sharp {note_class[1]}'>
                {notes[1]}
            </span>
            <span class='flat {note_class[2]}'>
                {notes[2]}
            </span>
            ")
    }

    if (!is_accidental) {
        note_class <- note_value %>%
            tolower() %>%
            paste0("-note")
        note_span <- glue("
            <span class='natural {note_class}'>
                {note_value}
            </span>
            ")
    }


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

    style_container <- glue("
        background-color: {background_colour};
        height: 100%;
        width: 100%;
    ")

    style_dot <- paste0(
        "--gradient: ", gradient_colour, ";
            --gradient-edge: ", gradient_edge_colour, ";
            --dot-text: ", dot_text_colour, ";
            "
    )

    glue("
        <div class='dot-container' style = '{style_container}'>
            <span class='dot' style ='{style_dot}'>
              <span class='dot-text'>
                {note_span}
              </span>
            </span>
        </div>
    ")
}

as_note_html_v <- Vectorize(as_note_html)

# Return note with its enharmonic equivalent
include_enharmonics <- function(note) {
    # Length not 2 is a natural or something weird, so gaurd it
    if (nchar(note) != 2) {
        return(note)
    }

    note_split <- strsplit(note, "") %>% pluck(1)
    accidental <- note_split[2]
    interval <- iff(accidental == "q", 1, -1)

    enharmonic <- list(
        letter = next_note(note, interval),
        accidental = iff(accidental == "q", "p", "q")
    ) %>% paste(collapse = "")

    c(note, enharmonic)
}

coord_to_letter_octave <- function(coord) {
    interval <- coord$fret %>%
        str_replace("fret", "") %>%
        as.integer()
    open_note <- k$open_notes[coord$row]
    open_octave <- k$open_octaves[coord$row]

    # Get all notes in interval to determine octave changes
    # Use flats (consistent with audio file names)
    notes <- 0:interval %>%
        map_chr(~ next_note(open_note, .x) %>% tail(1))

    c_count <- sum(notes == "C") - (open_note == "C")
    octave <- open_octave + c_count

    notes %>%
        tail(1) %>%
        str_replace("p", "b") %>%
        paste0(octave)
}
