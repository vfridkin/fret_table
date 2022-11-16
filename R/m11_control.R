control_ui <- function(id) {
  ns <- NS(id)

  game_choices <- ac$game$id %>% set_names(ac$game$name)
  game_selected <- ac$game[default == 1]$id

  range_choices <- ac$range$id %>% set_names(ac$range$name)
  range_selected <- ac$range[default == 1]$id

  turns_choices <- c(5, 10, 20) %>% set_names(paste(., "turns"))
  turns_selected <- k$default_turns

  # Transport and game choices

  tagList(
    div(
      id = "control_div",
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
        transport_button(ns("info_button"),
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
        width: -webkit-calc(100vw - 290px);
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
      width: 70px;
      vertical-align: top;
      margin-left: -20px
      ",
        img(
          height = 100,
          src = "plectrum.png",
          alt = "My Performance Image"
        )
      ) # div
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
        start_time = NULL,
        temp_log = NULL, # Saved only when game completes
        saved_log = NULL
      )

      observeEvent(m$run_once,
        {
          state$saved_log <- load_saved_log(session)
        },
        once = TRUE
      )

      # Transport buttons ------------------------------------------------------

      # > Info -----------------------------------------------------------------
      observeEvent(
        input$info_button,
        {
          introjs(
            session,
            options = list(
              steps = help_steps(),
              nextLabel = "Next",
              skipLabel = "x",
              showStepNumbers = FALSE,
              showBullets = TRUE,
              disableInteraction = TRUE
            )
          )
        }
      )

      # > Play -----------------------------------------------------------------
      observeEvent(input$play_button, {
        set_state_playing(session)
      })

      # > Stop -----------------------------------------------------------------
      observeEvent(input$stop_button, {
        set_state_learning(session)
      })

      # Game settings ----------------------------------------------------------
      observeEvent(
        input$game_select,
        {
          no_select <- is.null(input$game_select)

          # Ensure minimum of 1 selection
          if (no_select) {
            shiny::updateSelectizeInput(
              session,
              "game_select",
              selected = ac$game[default == 1]$id
            )
            return()
          }

          m$game_select <- input$game_select
        },
        ignoreNULL = FALSE
      )

      observeEvent(
        input$range_select,
        {
          no_select <- is.null(input$range_select)

          # Ensure minimum of 1 selection
          if (no_select) {
            shiny::updateSelectizeInput(
              session,
              "range_select",
              selected = ac$range[default == 1]$id
            )
            return()
          }
          m$range_select <- input$range_select
        },
        ignoreNULL = FALSE
      )

      observeEvent(
        input$turns_select,
        m$turns_select <- input$turns_select %>% as.integer()
      )

      # Game timer -------------------------------------------------------------
      play_duration <- reactive({
        if (state$is_playing) {
          invalidateLater(1000)
          state$play_seconds <- difftime(
            Sys.time(),
            state$start_time,
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

      # Game questions ---------------------------------------------------------
      questions <- eventReactive(
        list(
          state$is_playing,
          state$start_time
        ),
        {
          req(state$is_playing)
          game <- m$game_select
          range <- m$range_select
          turns <- m$turns_select

          get_questions(game, range, turns)
        }
      )

      # Game turn --------------------------------------------------------------

      observeEvent(
        state$play_turn,
        {
          req(state$is_playing)

          turn <- state$play_turn
          req(turn > 0)

          state$question <- questions()[turn]
        }
      )

      observeEvent(
        list(
          state$fret_select,
          state$letter_select
        ),
        {
          req(state$is_playing)
          source <- state$input_source
          question <- state$question
          question_source <- strsplit(question$type, "_") %>% pluck(1, 2)

          valid_source <- source == question_source
          if (!valid_source) {
            return()
          }

          if (source == "letter") {
            response <- state$letter_select %>% letter_to_note()
          }

          if (source == "fret") {
            response <- state$fret_select
          }

          log_row <- make_log_row(
            question,
            response,
            source,
            state$start_time,
            state$play_seconds
          )

          # Log results (remove dummy X)
          state$temp_log <- rbindlist(list(state$temp_log, log_row))[note != "X"]

          # Go to next turn
          state$play_turn <- state$play_turn + 1
        }
      )

      # Complete game ----------------------------------------------------------
      observeEvent(
        state$play_turn,
        {
          if (state$play_turn > m$turns_select) {
            set_state_completed(session)
          }
        }
      )

      # Show results of game
      observeEvent(
        state$is_completed_game,
        {
          if (!state$is_completed_game) {
            return()
          }

          log <- state$temp_log

          # show_game_results_fret(log)
          # show_game_results_letter(log)

          # Create new log for saving (remove dummy "X")
          new_log <- rbindlist(list(state$saved_log, log))

          # Limit log if over max saved games
          limited_times <- new_log$start_time %>%
            unique() %>%
            tail(k$max_saved_games)

          new_log <- new_log[start_time %in% limited_times]

          save_log(session, new_log)
          state$saved_log <- new_log
        }
      )

      # Game score -------------------------------------------------------------
      score <- eventReactive(
        state$temp_log,
        {
          turns <- m$turns_select
          col_names <- paste0("s", 1:turns)
          log <- state$temp_log

          no_log <- any(
            is.null(log),
            nrow(log) == 0
          )

          if (no_log) {
            df <- rep("", turns) %>%
              as.list() %>%
              setDT() %>%
              set_names(col_names)
            return(df)
          }

          correct <- log$correct %>%
            as.character() %>%
            map_chr(~ k$answer_html[[.x]])

          add_fill <- length(correct) < turns
          if (add_fill) {
            fill <- rep("", turns - length(correct))
            correct <- c(correct, fill)
          }

          df <- setDT(as.list(correct))[]
          if (ncol(df) != turns) browser()
          names(df) <- col_names

          df
        }
      )

      output$score <- renderReactable({
        df <- score()

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
