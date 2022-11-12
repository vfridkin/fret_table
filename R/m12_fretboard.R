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

      # fret table raw
      fret_data <- eventReactive(
        list(
          state$letter_select
        ),
        {
          display <- state$letter_select

          df <- k$open_notes %>%
            map(
              function(open_note) {
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
        columns <- get_col_def(k$fret_count)

        hover_input <- ns("fret_hover")
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
        input$fret_hover,
        {
          req(state$is_learning)
          browser()
          state$fret_select <- input$fret_hover
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
            tail(2)
          print(cell_coords)
          state$fret_select <- cell_coords
        }
      )
    } # function
  ) # moduleServer
} # fretboard_server


get_col_def <- function(fret_count) {
  headstock_coldef <- list(
    fret0 = colDef(
      name = "",
      class = "headstock-string",
      style = function(value, index, name) {
        paste0(
          "position: relative;
          --thickness: ", k$string_thickness[index], "px;
          --rotation: ", k$string_rotation[index], "deg;
          "
        )
      }
    )
  )

  fret_names <- paste0("fret", 1:k$fret_count)

  fret_min_width <- function(fret) {
    round(50 * (1 - fret / 24))
  }

  frets_coldef <- 1:k$fret_count %>%
    map(
      function(fret) {
        colDef(
          name = "",
          minWidth = fret_min_width(fret),
          html = TRUE,
          align = "center",
          class = function(value, index, name) {
            paste("guitar-string", index, name)
          },
          style = function(value, index, name) {
            paste0(
              "position: relative; --thickness: ", k$string_thickness[index], "px;"
            )
          }
        )
      }
    ) %>%
    set_names(fret_names)

  c(headstock_coldef, frets_coldef)
}
