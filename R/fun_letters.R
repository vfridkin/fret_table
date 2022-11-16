#' Highlight letter
#' @param highlight note name and accidental
#' @param role one of: question (default), right, wrong
#' When playing, role = question (hides the note text), then right/wrong
#' depending on the answer
#' @return side effect - highlights letter
letter_highlight <- function(session,
                             letter,
                             role = "question") {
    # Hide all dots and questions
    dot_visibility(session, FALSE)
    clear_questions(session)

    # Guard nothing to highlight
    nothing_to_highlight <- any(
        is.null(letter),
        letter == ""
    )
    if (nothing_to_highlight) {
        return()
    }

    # Remainder is single letter
    letter_add_highlight(session, letter, role)
}

letter_add_highlight <- function(session, letter = "", role = "question") {
    letter_class <- glue("{letter}-letter")
    highlight_colour <- k$colour[[role]]

    session$sendCustomMessage(
        "letter_add_highlight",
        list(
            letter_class = letter_class,
            role = role,
            highlight_colour = highlight_colour,
            colour = k$colour$accidental
        )
    )
}

Learn_letters_visibility <- function(session, visible) {
    session$sendCustomMessage("Learn_letters_visibility", visible)
}
