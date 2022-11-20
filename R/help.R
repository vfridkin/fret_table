help_steps <- function() {
    # Override icon to make work in help steps
    icon_strong <- function(name) {
        icon(
            style = "font-family: \"Font Awesome 5 Free\";
        color: black;",
            name
        )
    }
    info <- div(
        p("Improve your accuracy and speed with the freboard."),
        p(
            "FretTable has three modes:",
            tags$ul(
                tags$li("Learn"),
                tags$li("Play"),
                tags$li("Performance")
            )
        ),
        p(
            "In", strong("Learn"), "mode, hover over the frets to view
            individual notes. Hover over the letters below to view groups
            of notes."
        ),
        p(
            "In ", strong("Play"), " mode, race against time identifying
            notes on the fret, or associated letter."
        ),
        p(
            "In ", strong("Performance"), " mode, view your accuracy and
            speed over multiple games.  Up to 100 most recent games are saved
            in your browser memory automatically."
        ),
    ) %>% as.character()

    transport <- div(
        p("Start/stop the game and info"),
        p(
            icon_strong("play"),
            "Press play to enter", strong("Play"), "mode and start the timer.
            Press again during a game to restart without saving."
        ),
        p("Correct answers are indicated by a green note, incorrect ones by
        a red cross."),
        p(
            icon_strong("stop"),
            "Press stop to enter", strong("Learn"), "mode. If pressed before
            the end of a game, progress is not saved."
        )
    ) %>% as.character()

    settings <- div(
        p("Use drop-downs to set up the (1) game type, (2) range of questions and (3) number of turns per game.  The game types are:"),
        p(
            strong("Click the fretboard"), " to match fret notes with highlighted letters below."
        ),
        p(
            strong("Choose the letter"), " to match with the highlighted fret note."
        ),
        p(
            "When there are multiple right answers (enharmonics or a letter appearing in multiple positions on the fretboards)
            then any right answer will do."
        )
    ) %>% as.character()

    timer_score <- div(
        p("Game progress appears to the right of the timer."),
        p(
            strong(span(style = glue("color: {k$colour$right}; font-size: x-large;"), "♪")), " green notes indicate a right answer."
        ),
        p(
            strong(span(style = glue("color: {k$colour$wrong}; font-size: x-large;"), "×")), " red x's indicate a wrong answer."
        ),
        p(
            "When the game completes, these will appear on the fretboard."
        )
    ) %>% as.character()

    performance <- div(
        p("View your performance over multiple games"),
        p(
            "Click the plectrum to toggle between performance and learning modes."
        ),
        p(
            "View your performance for up to 100 saved games, including accuracy, number of games played and questions answered."
        ),
        p(
            "In performance mode, the fretboard will become an accuracy heat map.  Notes with higher accuracy are greener, lower accuracy are redder."
        )
    ) %>% as.character()


    fretboard <- div(
        p("In Learn mode hover to view note names."),
        p("To switch between sharps and flats showing for enharmonic notes,
        use the switch on the bottom right."),
    ) %>% as.character()

    letters_div <- div(
        p("In Learn mode hover over the buttons to view related notes
         in the fret above."),
        p("All(x) buttons show all notes and accidentals of type x."),
        p("When not learning, buttons not referring to a single
        note are hidden.")
    ) %>% as.character()


    data.frame(
        title = c(
            "Info",
            "Transport",
            "Game settings",
            "Timer and score",
            "My performance",
            "Fretboard",
            "Letters"
        ),
        intro = c(
            info,
            transport,
            settings,
            timer_score,
            performance,
            fretboard,
            letters_div
        ),
        element = c(
            ".header__text-box",
            "#main-control-transport_div",
            "#main-control-settings_div",
            "#main-control-timer_score_div",
            "#main-plectrum",
            "#fretboard_div",
            "#main-letters-letters_div"
        ),
        position = c(
            "bottom-middle-aligned",
            "right",
            "auto",
            "auto",
            "left",
            "auto",
            "auto"
        )
    )
}
