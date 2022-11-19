state <- reactiveValues(
    is_learning = TRUE,
    is_playing = FALSE,
    is_completed_game = FALSE,
    is_performance = FALSE,
    start_time = NULL,
    play_seconds = 0,
    play_turn = 0,
    question = NULL,
    fret_select = NULL,
    letter_select = NULL,
    input_source = NULL,
    saved_log = NULL,
    temp_log = NULL,
    performance_data = NULL
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

    if (state$is_performance) {
        return("My performance")
    }
}

set_state_learning <- function(session) {
    state$is_learning <- TRUE
    state$is_playing <- FALSE
    state$is_completed_game <- FALSE
    state$is_performance <- FALSE
    state$play_seconds <- 0
    state$play_turn <- 0
    state$temp_log <- create_new_log()
    Learn_letters_visibility(session, TRUE)
    clear_game_results(session)
    selectize_disable(session, FALSE)
}

set_state_playing <- function(session) {
    state$is_learning <- FALSE
    state$is_playing <- TRUE
    state$is_completed_game <- FALSE
    state$is_performance <- FALSE
    state$play_seconds <- 0
    state$play_turn <- 1
    state$start_time <- Sys.time()
    state$temp_log <- create_new_log()
    Learn_letters_visibility(session, FALSE)
    clear_game_results(session)
    selectize_disable(session, TRUE)
}

set_state_completed <- function(session) {
    state$is_learning <- FALSE
    state$is_playing <- FALSE
    state$is_completed_game <- TRUE
    state$is_performance <- FALSE
    clear_questions(session)
    dot_visibility(session, FALSE)
    selectize_disable(session, FALSE)
}

set_state_performance <- function(session) {
    state$is_learning <- FALSE
    state$is_playing <- FALSE
    state$is_completed_game <- FALSE
    state$is_performance <- TRUE
    clear_questions(session)
    dot_visibility(session, FALSE)
    selectize_disable(session, FALSE)
}

selectize_disable <- function(session, disable) {
    session$sendCustomMessage("selectize_disable", disable)
}
