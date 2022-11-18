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

    control <- div(
        p("Start/stop the game, game settings and view performance."),
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
        ),
        p(
            "Use the drop downs customise your game."
        ),
        p(
            "Click on the plectrum (far right) to view your performance over
            multiple games."
        ),
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
            "Game controls",
            "Fretboard",
            "Letters"
        ),
        intro = c(
            info,
            control,
            fretboard,
            letters_div
        ),
        element = c(
            ".header__text-box",
            "#main-control-control_div",
            "#fretboard_div",
            "#main-letters-letters_div"
        )
    )
}
