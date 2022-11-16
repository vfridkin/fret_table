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
    input_source = NULL,
    saved_log = NULL,
    temp_log = NULL
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

set_state_learning <- function(session) {
    state$is_learning <- TRUE
    state$is_playing <- FALSE
    state$is_completed_game <- FALSE
    state$play_seconds <- 0
    state$play_turn <- 0
    state$temp_log <- create_new_log()
    Learn_letters_visibility(session, TRUE)
}

set_state_playing <- function(session) {
    state$is_learning <- FALSE
    state$is_playing <- TRUE
    state$is_completed_game <- FALSE
    state$play_seconds <- 0
    state$play_turn <- 1
    state$start_time <- Sys.time()
    state$temp_log <- create_new_log()
    Learn_letters_visibility(session, FALSE)
}

set_state_completed <- function(session) {
    state$is_learning <- FALSE
    state$is_playing <- FALSE
    state$is_completed_game <- TRUE
    clear_questions(session)
    dot_visibility(session, FALSE)
}
