# Fretboard has a headstock and at least 12 frets
# Headstock is fret0

fretboard_ui <- function(id) {
  ns <- NS(id)

  tagList(
    div(
      id = "fretboard_div",
      fluidRow(
        style = "margin-top: 30px;",
        reactableOutput(ns("fretboard_rt"))
      ), # Row
      fluidRow(
        column(
          style = "margin-top: 3px; height: 5px; z-index: 10;",
          offset = 4,
          width = 4,
          align = "center",
          uiOutput(ns("completed_choices_ui"))
        ),
        column(
          style = "margin-top: 3px; height: 5px; z-index: 10;",
          width = 4,
          align = "right",
          uiOutput(ns("default_accidental_ui"))
        )
      ) # fluidRow
    ) # div
  ) # tagList
}

fretboard_server <- function(id, k_, r_ = reactive(NULL)) {
  moduleServer(
    id,
    function(input, output, session) {
      ns <- session$ns

      m <- reactiveValues(
        run_once = FALSE,
        default_accidental = NULL
      )

      observeEvent(
        m$run_once,
        {
          m$default_accidental <- "sharp"
        },
        once = TRUE
      )

      # fret table without html formatting
      fret_data <- {
        note_count <- length(k$open_notes)
        rows <- 1:note_count

        df <- rows %>%
          map(
            function(row) {
              open_note <- k$open_notes[row]
              string_notes_with_joined_accidentals(open_note)
            }
          ) %>%
          as.data.table() %>%
          t() %>%
          as.data.table() %>%
          set_names(k$fret_names)

        df
      }

      # fret table with formatting
      fret_html <- {
        df <- fret_data
        cols <- k$fret_names
        df <- df[, (cols) := lapply(.SD, as_note_html_v), .SDcols = cols]
        df <- df %>% add_fret_markers()
        df
      }


      output$fretboard_rt <- renderReactable({
        df <- fret_html
        columns <- get_fret_col_def(k$fret_count)

        # Hover is handled by script.js
        click_input <- ns("fret_click")

        reactable(
          df,
          columns = columns,
          sortable = FALSE,
          defaultColDef = colDef(
            headerClass = "score-header",
            html = TRUE,
            minWidth = 50,
            align = "center"
          ),
          onClick = JS(paste0(
            "function(rowInfo, column) {
              if (window.Shiny) {
                console.log(rowInfo);
                console.log(column);
                Shiny.setInputValue('",
            click_input,
            "', {row: rowInfo.index + 1, fret: column.id},
              {priority: 'event' })
              }
            }"
          ))
        )
      })

      # Only show these choices after game is completed
      output$completed_choices_ui <- renderUI({
        if (state$is_completed_game) {
          checkboxGroupButtons(
            inputId = ns("completed_action"),
            label = NULL,
            choices = k$completed_action_choices,
            selected = NULL
          )
        } else {
          NULL
        }
      })

      observeEvent(input$completed_action, {
        action <- input$completed_action
        if (action == "play") set_state_playing(session)
        if (action == "learn") set_state_learning(session)
      })

      # Choose the default accidental to show in the fretboard when learning
      output$default_accidental_ui <- renderUI({
        if (state$is_learning) {
          radioGroupButtons(
            inputId = ns("default_accidental"),
            label = NULL,
            choices = k$default_accidental_choices,
            selected = m$default_accidental
          )
        } else {
          NULL
        }
      })

      observeEvent(input$default_accidental, {
        m$default_accidental <- input$default_accidental
      })

      ## LEARNING --------------------------------------------------------------
      # > Clean up after playing -----------------------------------------------
      observeEvent(
        state$is_learning,
        {
          if (state$is_learning) {
            dot_visibility(session, FALSE)
            clear_questions(session)
          }
        }
      )

      # > Observe fret ---------------------------------------------------------
      observeEvent(
        input$fret_cell_hover,
        {
          req(state$is_learning)
          cell_class <- input$fret_cell_hover
          cell_coords <- cell_class %>%
            strsplit(" ") %>%
            pluck(1) %>%
            tail(2) %>%
            set_names(c("string", "fret")) %>%
            as.list()
          state$fret_select <- cell_coords
          state$input_source <- "fret"
        }
      )

      # > Display fret cells ---------------------------------------------------
      observeEvent(
        state$letter_select,
        {
          if (state$is_learning) {
            fret_visible_from_letter(
              session,
              state$letter_select
            )
          }
        }
      )

      observeEvent(
        state$fret_select,
        {
          if (state$is_learning) {
            fret_visible_from_fretboard(
              session,
              state$fret_select,
              m$default_accidental
            )
          }
        }
      )

      ## PLAYING ---------------------------------------------------------------
      # > Observe fret ---------------------------------------------------------
      observeEvent(
        input$fret_click,
        {
          req(state$is_playing)
          state$fret_select <- list(
            val = input$fret_click,
            time = Sys.time()
          )
          state$input_source <- "fret"
        }
      )

      # > Display question -----------------------------------------------------
      observeEvent(
        state$question,
        {
          if (state$is_playing) {
            question <- state$question

            # Display on fret when player has to choose the matching note letter
            req(question$type == "note_letter")

            fret_select <- list(
              string = paste0("string", question$row),
              fret = question$fret
            )

            fret_visible_from_fretboard(
              session,
              fret_select,
              m$default_accidental,
              role = "question"
            )
          }
        }
      ) # observeEvent
    } # function
  ) # moduleServer
} # fretboard_server
