#' Make performance data
#' @param df saved log
#' @return list of performance values and datatables
make_performance_data <- function(df) {
    no_saved_data <- any(is.null(df), nrow(df) == 0)

    if (no_saved_data) {
        return(
            list(
                chart_data = NULL,
                fret_data = NULL,
                letter_data = NULL,
                accuracy = 0,
                games = 0,
                questions = 0
            )
        )
    }

    # Questions
    questions <- nrow(df)

    # Chart data
    chart_data <- df[
        , .(
            accuracy = sum(correct) / .N,
            speed = .N / max(play_time)
        ),
        by = start_time
    ][, game := .I]

    # Accuracy
    accuracy <- sum(df$correct) / questions

    # Games
    games <- max(chart_data$game)

    # Frets
    fret_data <- df[
        , .(
            accuracy = sum(correct) / .N,
            count = .N
        ),
        by = .(row, column)
    ]

    # Letters
    letter_data <- df[
        , .(
            accuracy = sum(correct) / .N,
            count = .N
        ),
        by = .(note)
    ]

    list(
        chart_data = chart_data,
        fret_data = fret_data,
        letter_data = letter_data,
        accuracy = accuracy,
        games = games,
        questions = questions
    )
}

performance_colour <- function(x) {
    if (is.na(x)) {
        return("transparent")
    }
    rgb(colorRamp(c(k$colour$wrong, k$colour$right))(x), maxColorValue = 255)
}

performance_colour_v <- Vectorize(performance_colour)
