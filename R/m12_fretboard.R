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

      output$fretboard_rt <- renderReactable({
        # Fretboard has a headstock and at least 12 frets
        # Headstock is fret0

        learn_select <- state$learn_select

        accidental <- iff("flat" %in% learn_select, "flat", "sharp")
        fret_names <- paste0("fret", 0:k$fret_count)

        df <- k$open_notes %>%
          map(
            function(open_note) {
              string_notes(open_note, accidental) %>%
                map_chr(as_note_html)
            }
          ) %>%
          as.data.table() %>%
          t() %>%
          as.data.table() %>%
          set_names(fret_names)

        # Add fret markers
        cols <- paste0("fret", c(3, 5, 7, 9))
        fn <- function(x) paste0("<span class='fret-marker'></span>", x)
        fn2 <- function(x) paste0("<span class='fret-marker2'></span>", x)

        df[3, (cols) := lapply(.SD, fn), .SDcols = cols]
        df[c(2, 4), fret12 := fn(fret12)]
        df[4, (cols) := lapply(.SD, fn2), .SDcols = cols]
        df[c(3, 5), fret12 := fn2(fret12)]

        columns <- get_col_def(k$fret_count)

        click_input <- ns("string_select")

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

      # Observe string select --------------------------------------------------
      observeEvent(
        input$string_select,
        {
          req(input$string_select)
          print(input$string_select)
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
          class = "guitar-string",
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