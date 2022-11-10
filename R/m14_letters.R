letters_ui <- function(id) {
  ns <- NS(id)

  in_row <- function(ui, width) {
    edge_width <- (12 - width) / 2
    fluidRow(
      column(
        offset = edge_width,
        width = width,
        ui
      )
    )
  }

  width <- 6

  div(
    id = ns("piano"),
    style = "margin-top: 7px;",
    in_row(reactableOutput(ns("sharps_rt")), width),
    in_row(reactableOutput(ns("naturals_rt")), width),
    in_row(reactableOutput(ns("flats_rt")), width)
  )
}

letters_server <- function(id, k_, r_ = reactive(NULL)) {
  moduleServer(
    id,
    function(input, output, session) {
      ns <- session$ns

      m <- reactiveValues(
        run_once = TRUE
      )

      output$sharps_rt <- renderReactable({
        # C♯ -> A♯
        list(
          halfkey1 = "",
          c_sharp = "C♯",
          d_sharp = "D♯",
          nokey1 = "",
          f_sharp = "F♯",
          g_sharp = "G♯",
          a_sharp = "A♯",
          halfkey2 = ""
        ) %>% to_reactable()
      })

      output$naturals_rt <- renderReactable({
        # C -> B
        list(
          c_natural = "C",
          d_natural = "D",
          e_natural = "E",
          f_natural = "F",
          g_natural = "G",
          a_natural = "A",
          b_natural = "B"
        ) %>% to_reactable()
      })

      output$flats_rt <- renderReactable({
        # D♭ -> B♭
        list(
          halfkey1 = "",
          d_flat = "D♭",
          e_flat = "E♭",
          nokey1 = "",
          g_flat = "G♭",
          a_flat = "A♭",
          b_flat = "B♭",
          halfkey2 = ""
        ) %>% to_reactable()
      })


      to_reactable <- function(notes) {
        columns <- get_note_col_def(notes)
        df <- data.table(t(notes))

        reactable(
          df,
          columns = columns,
          sortable = FALSE,
          defaultColDef = colDef(
            headerClass = "score-header",
            html = TRUE,
            minWidth = 30,
            align = "center"
          )
        )
      }

      get_note_col_def <- function(notes) {
        notes %>%
          imap(
            function(value, name) {
              is_halfkey <- str_detect(name, "halfkey")
              is_nokey <- str_detect(name, "nokey")
              is_key <- str_detect(name, "sharp|natural|flat")

              if (is_halfkey) {
                res <- colDef(name = "", minWidth = 15)
              }
              if (is_nokey) {
                res <- colDef(name = "")
              }
              if (is_key) {
                is_accidental <- str_detect(name, "sharp|flat")

                background_index <- iff(is_accidental, "accidental", "natural")
                text_index <- iff(is_accidental, "natural", "accidental")

                background_colour <- k$colour[[background_index]]
                text_colour <- k$colour[[text_index]]

                res <- colDef(
                  name = "",
                  cell = function(value, rowIndex, colName) {
                    as.character(tags$div(
                      style = "height: 100%; width: 100%;",
                      tags$button(
                        value,
                        class = "letter",
                        style = paste0(
                          "--letter-background-colour:", background_colour,
                          "; --letter-text-colour: ", text_colour
                        ),
                        onclick = sprintf("", name)
                      ),
                    )) # sprintf('alert("approve - %s")', name)
                  }
                )
              }
              res
            }
          ) %>%
          set_names(names(notes))
      }
    } # function
  ) # moduleServer
} # letters_server
