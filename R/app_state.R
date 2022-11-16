state <- reactiveValues(
    is_learning = TRUE,
    is_playing = FALSE,
    is_completed_game = FALSE,
    start_time = NULL,
    play_seconds = 0,
    play_turn = 0,
    question = NULL,
    fret_select = NULL,
    letter_select = NULL,
    input_source = NULL
)

get_state_title <- function(state) {
    if (state$is_learning) {
        return("Learn")
    }
    if (state$is_playing) {
        return("Playing...")
    }
    if (state$is_completed_game) {
        return("Game over!")
    }
}

set_state_learning <- function() {
    state$is_learning <- TRUE
    state$is_playing <- FALSE
    state$is_completed_game <- FALSE
    state$play_seconds <- 0
    state$play_turn <- 0
}

set_state_playing <- function() {
    state$is_learning <- FALSE
    state$is_playing <- TRUE
    state$is_completed_game <- FALSE
    state$play_seconds <- 0
    state$play_turn <- 1
    state$start_time <- Sys.time()
}

set_state_completed <- function() {
    state$is_learning <- FALSE
    state$is_playing <- FALSE
    state$is_completed_game <- TRUE
}
