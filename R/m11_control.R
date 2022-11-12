control_ui <- function(id) {
  ns <- NS(id)

  game_choices <- ac$game$id %>% set_names(ac$game$name)
  game_selected <- ac$game[default == 1]$id

  range_choices <- ac$range$id %>% set_names(ac$range$name)
  range_selected <- ac$range[default == 1]$id

  turns_choices <- c(5, 10, 20) %>% set_names(paste(., "turns"))
  turns_selected <- 10

  # Transport and game choices

  tagList(
    div(style = "margin-top: 5px;"),
    div(
      style = "
        display: inline-block;
        width: 90px;
        vertical-align: top;
        padding-top: 5px;
      ",
      transport_button(ns("play_button"), "play",
        width = "80px",
        style = glue("
        height: 80px;
        font-size: xx-large;
        color: {k$colour$button_text};
        background-color: {k$colour$button_play};
        ")
      )
    ),
    div(
      style = "
        display: inline-block;
        width: 50px;
        vertical-align:
        top; padding-top: 5px;
      ",
      transport_button(ns("setting_button"),
        "info",
        style = glue("
          height: 35px;
          color: {k$colour$button_text};
          background-color: {k$colour$button_info};
          font-size: larger;
        ")
      ),
      transport_button(ns("stop_button"),
        "stop",
        style = glue("
        height: 35px;
        color: {k$colour$button_text};
        background-color: {k$colour$button_stop};
        ")
      )
    ),
    div(
      style = "
        display: inline-block;
        width: -webkit-calc(100vw - 280px);
        height: 50px;
        ",
      fillRow(
        flex = c(5, 3, 3),
        inline_selector(ns("game_select"),
          game_choices, game_selected,
          width = "100%"
        ),
        inline_selector(ns("range_select"),
          range_choices, range_selected,
          width = "100%"
        ),
        inline_selector(ns("turns_select"),
          turns_choices, turns_selected,
          width = "100%", multiple = FALSE
        )
      ) # Row
      , fillRow(
        flex = c(1, 5),
        div(
          style = "
            display: flex;
            font-size: xx-large;
            padding-left: 10px;
            text-align: center;
            width: 100%;
            ",
          textOutput(ns("timer"))
        ),
        div(
          style = "
            display: flex;
            font-size: xx-large;
            font-weight: 900;
            margin-top: -10px;
            padding-left: 5px;
            ",
          reactableOutput(ns("score"), width = "100%")
        )
      ) # Row
    ) # div
    , div(
      style = "
      display: inline-block;
      width: 80px;
      vertical-align: top;
      margin-left: 10px
      ",
      img(
        height = 100,
        src = "pick_achu.png",
        alt = "Opponent image"
      )
    ) # div
  ) # tagList
}

control_server <- function(id, k_, r_ = reactive(NULL)) {
  moduleServer(
    id,
    function(input, output, session) {
      ns <- session$ns

      m <- reactiveValues(
        run_once = TRUE,
        game_select = NULL,
        range_select = NULL,
        turns_select = NULL,
        start_time = NULL
      )

      # Transport buttons ------------------------------------------------------

      # > Play -----------------------------------------------------------------
      observeEvent(input$play_button, {
        state$is_playing <- TRUE
        state$play_seconds <- 0
        m$start_time <- Sys.time()
      })

      # > Stop -----------------------------------------------------------------
      observeEvent(input$stop_button, {
        state$is_playing <- FALSE
        state$play_seconds <- 0
      })

      observeEvent(
        input$turns_select,
        m$turns_select <- input$turns_select
      )

      answer <- list(
        "TRUE" = glue("
          <span style = '
          color: {k$colour$button_info};
          padding: 0;
          '>♪</span>"),
        "FALSE" = glue("
          <span style = '
            color: {k$colour$button_stop};
            padding: 0;
          '>×</span>")
      )

      play_duration <- reactive({
        if (state$is_playing) {
          invalidateLater(1000)
          state$play_seconds <- difftime(
            Sys.time(),
            m$start_time,
            units = "secs"
          )
        }
        state$play_seconds
      })


      output$timer <- renderText({
        td <- seconds_to_period(play_duration())
        seconds <- round(second(td))
        minutes <- round(minute(td))
        sprintf("%02d:%02d", minutes, seconds)
      })

      output$score <- renderReactable({
        # Initialise data to have an empty score
        df <- data.table(s1 = "")

        col_names <- paste0("s", 1:m$turns_select)

        for (col in col_names) {
          df[[col]] <- answer[["FALSE"]]
        }

        reactable(
          df,
          defaultColDef = colDef(
            headerClass = "score-header",
            html = TRUE,
            minWidth = 24,
            maxWidth = 200
          )
        )
      })
    } # function
  ) # moduleServer
} # control_server
