state <- reactiveValues(
    is_learning = FALSE,
    is_playing = FALSE,
    is_completed_game = FALSE,
    play_seconds = 0,
    fret_select = NULL,
    letter_select = NULL
)

observeEvent(
    state$fret_select,
    {
        message("FRET SELECT")
        print(state$fret_select)
    }
)

observeEvent(
    state$letter_select,
    {
        message("LETTER SELECT")
        print(state$letter_select)
    }
)
