fretboard_ui <- function(id) {
  ns <- NS(id)

  tagList(
    fillRow(
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

        string_count <- 6
        fret_count <- 12

        df <- data.table(headstock = string_count:1)
        for (fret in 1:fret_count) {
          df[[paste0("fret", fret)]] <- string_count:1
        }

        columns <- get_col_def(fret_count)

        reactable(
          df,
          columns = columns,
          sortable = FALSE,
        )
      })
    } # function
  ) # moduleServer
} # fretboard_server

get_col_def <- function(fret_count) {
  headstock_coldef <- list(
    headstock = colDef(
      name = "",
      minWidth = 50,
      html = TRUE,
      align = "center",
      class = "headstock-string",
      style = function(value, index, name) {
        paste0(
          "position: relative; --thickness: ", thickness[index], "px;"
        )
      }
    )
  )

  fret_names <- paste0("fret", 1:fret_count)

  thickness <- c(4, 3, 2, 2, 1, 1)

  frets_coldef <- 1:fret_count %>%
    map(
      ~ colDef(
        name = "",
        minWidth = 50,
        html = TRUE,
        align = "center",
        class = "guitar-string",
        style = function(value, index, name) {
          paste0(
            "position: relative; --thickness: ", thickness[index], "px;"
          )
        }
      )
    ) %>%
    set_names(fret_names)

  c(headstock_coldef, frets_coldef)
}
