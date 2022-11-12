letters_ui <- function(id) {
  ns <- NS(id)

  in_row <- function(ui, width) {
    fluidRow(
      column(
        width = 12,
        ui
      )
    )
  }

  width <- 8

  div(
    id = ns("piano"),
    style = "margin-top: 7px; width: 100vw; padding: 1vw;",
    in_row(reactableOutput(ns("title_rt")), width),
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

      output$title_rt <- renderReactable({
        # Titles - in order to align with table

        title <- iff(state$is_playing, "Playing...", "Learn")

        list(
          edgekey1 = "",
          nokey1 = title,
          nokey2 = "",
          nokey3 = "",
          nokey4 = "",
          nokey5 = "",
          nokey6 = "",
          nokey7 = "",
          nokey8 = "",
          halfkey1 = "",
          edgekey2 = ""
        ) %>% to_reactable()
      })

      output$sharps_rt <- renderReactable({
        # C♯ -> A♯
        list(
          edgekey1 = "",
          all_sharp = "Sharps",
          nokey1 = "",
          c_sharp = "C♯",
          d_sharp = "D♯",
          nokey2 = "",
          f_sharp = "F♯",
          g_sharp = "G♯",
          a_sharp = "A♯",
          halfkey1 = "",
          edgekey2 = ""
        ) %>% to_reactable()
      })

      output$naturals_rt <- renderReactable({
        # C -> B
        list(
          edgekey1 = "",
          all_natural = "Naturals",
          halfkey1 = "",
          c_natural = "C",
          d_natural = "D",
          e_natural = "E",
          f_natural = "F",
          g_natural = "G",
          a_natural = "A",
          b_natural = "B",
          edgekey2 = ""
        ) %>% to_reactable()
      })

      output$flats_rt <- renderReactable({
        # D♭ -> B♭
        list(
          edgekey1 = "",
          all_flat = "Flats",
          nokey1 = "",
          d_flat = "D♭",
          e_flat = "E♭",
          nokey2 = "",
          g_flat = "G♭",
          a_flat = "A♭",
          b_flat = "B♭",
          halfkey1 = "",
          edgekey2 = ""
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
            name = "",
            headerClass = "score-header",
            html = TRUE,
            minWidth = 70,
            maxWidth = 120,
            align = "center"
          )
        )
      }

      get_note_col_def <- function(notes) {
        notes %>%
          imap(
            function(value, name) {
              is_edgekey <- str_detect(name, "edgekey")
              is_halfkey <- str_detect(name, "halfkey")
              is_nokey <- str_detect(name, "nokey")
              is_key <- str_detect(name, "sharp|natural|flat")
              is_learn <- str_detect(name, "learn")

              if (is_edgekey) {
                res <- colDef(minWidth = 10, maxWidth = 1000)
              }
              if (is_halfkey) {
                res <- colDef(minWidth = 35, maxWidth = 60)
              }
              if (is_nokey) {
                res <- colDef(
                  style = "
                  font-family: 'Brush Script MT', cursive;
                  font-size: x-large;"
                )
              }
              if (is_key) {
                # Hide learn buttons when playing
                is_visible <- any(!is_learn, !state$is_playing)
                visibility <- iff(is_visible, "visible", "hidden")

                is_accidental <- str_detect(name, "sharp|flat")

                background_index <- iff(is_accidental, "accidental", "natural")
                text_index <- iff(is_accidental, "natural", "accidental")

                background_colour <- k$colour[[background_index]]
                text_colour <- k$colour[[text_index]]

                click_input <- ns("letter_select")

                res <- colDef(
                  cell = function(value, rowIndex, colName) {
                    as.character(tags$div(
                      style = "height: 100%; width: 100%;",
                      tags$button(
                        value,
                        class = "letter",
                        style = paste0(
                          "--letter-background-colour:", background_colour,
                          "; --letter-text-colour: ", text_colour,
                          "; visibility: ", visibility
                        ),
                        onmouseover =
                          sprintf(
                            'Shiny.setInputValue("%s", "%s", {priority: "event"})',
                            click_input, colName
                          ),
                        # onmouseup =
                        #   sprintf(
                        #     'Shiny.setInputValue("%s", "%s", {priority: "event"})',
                        #     click_input, ""
                        #   ),
                        onmouseout =
                          sprintf(
                            'Shiny.setInputValue("%s", "%s", {priority: "event"})',
                            click_input, ""
                          )
                      ),
                    ))
                  }
                )
              }
              res
            }
          ) %>%
          set_names(names(notes))
      }

      # Observe learn buttons --------------------------------------------------
      observeEvent(
        input$letter_select,
        {
          state$letter_select <- input$letter_select
        }
      )
    } # function
  ) # moduleServer
} # letters_server
