# Fretboard has a headstock and at least 12 frets
# Headstock is fret0

fretboard_ui <- function(id) {
  ns <- NS(id)

  tagList(
    fluidRow(
      style = "margin-top: 30px;",
      reactableOutput(ns("fretboard_rt"))
    ), # Row
    fluidRow(
      column(
        style = "margin-top: 3px; height: 5px; z-index: 10;",
        width = 12,
        align = "right",
        uiOutput(ns("default_accidental_ui"))
      )
    )
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
            "', {row: rowInfo.index + 1, col: column.id},
              {priority: 'event' })
              }
            }"
          ))
        )
      })

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

      # Observe fret select --------------------------------------------------
      observeEvent(
        input$fret_click,
        {
          req(state$is_playing)
          state$fret_select <- input$fret_click
          state$input_source <- "fret"
        }
      )

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

      # Respond to letters -----------------------------------------------------
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

      # Respond to fret cells --------------------------------------------------
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
    } # function
  ) # moduleServer
} # fretboard_server
