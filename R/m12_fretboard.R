# Fretboard has a headstock and at least 12 frets
# Headstock is fret0

fretboard_ui <- function(id) {
  ns <- NS(id)

  tagList(
    fluidRow(
      style = "margin-top: 30px;",
      reactableOutput(ns("fretboard_rt"))
    ) # Row
  ) # tagList
}

fretboard_server <- function(id, k_, r_ = reactive(NULL)) {
  moduleServer(
    id,
    function(input, output, session) {
      ns <- session$ns

      m <- reactiveValues(
        run_once = TRUE
      )

      # fret table without html formatting
      fret_data <- eventReactive(
        list(
          state$letter_select,
          state$fret_select
        ),
        {
          note_count <- length(k$open_notes)
          source <- state$input_source %>% if_null_then("letter")

          this <- iff(
            source == "letter",
            list(
              rows = 1:note_count,
              display = state$letter_select
            ),
            display_from_fret(state$fret_select)
          )

          df <- 1:note_count %>%
            map(
              function(row) {
                open_note <- k$open_notes[row]
                display <- iff(row %in% this$rows, this$display, "")
                string_notes(open_note, display)
              }
            ) %>%
            as.data.table() %>%
            t() %>%
            as.data.table() %>%
            set_names(k$fret_names)

          df
        }
      )

      # fret table with formatting
      fret_display <- eventReactive(
        fret_data(),
        {
          df <- fret_data()
          cols <- k$fret_names
          df <- df[, (cols) := lapply(.SD, as_note_html_v), .SDcols = cols]
          df <- df %>% add_fret_markers()
          df
        }
      )


      output$fretboard_rt <- renderReactable({
        df <- fret_display()
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
          onClick = JS(paste0("function(rowInfo, column) {
              if (window.Shiny) {
                console.log(rowInfo);
                console.log(column);
                Shiny.setInputValue('", click_input, "', {row: rowInfo.index + 1, col: column.id}, { priority: 'event' })
              }
            }"))
        )
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
            set_names(c("row", "col")) %>%
            as.list()
          cell_coords$row %<>% as.integer()
          state$fret_select <- cell_coords
          state$input_source <- "fret"
        }
      )
    } # function
  ) # moduleServer
} # fretboard_server
