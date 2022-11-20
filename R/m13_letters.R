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
    style = "margin-top: 0px; width: 100vw; padding: 1vw;",
    div(
      id = ns("letters_div"),
      in_row(reactableOutput(ns("title_rt")), width),
      in_row(reactableOutput(ns("sharps_rt")), width),
      in_row(reactableOutput(ns("naturals_rt")), width),
      in_row(reactableOutput(ns("flats_rt")), width)
    )
  )
}

letters_server <- function(id, k_, r_ = reactive(NULL)) {
  moduleServer(
    id,
    function(input, output, session) {
      ns <- session$ns

      output$title_rt <- renderReactable({
        # Titles - in order to align with table
        title <- get_state_title(state)

        list(
          edgekey1 = "",
          halfkey1 = "",
          widekey = title,
          halfkey2 = "",
          edgekey2 = ""
        ) %>% to_reactable()
      })

      output$sharps_rt <- renderReactable({
        message("Rendering sharps_rt")
        # C♯ -> A♯
        list(
          edgekey1 = "",
          allplus_sharp = "All(♯)",
          all_sharp = "Sharps",
          halfkey1 = "",
          c_sharp = "C♯",
          d_sharp = "D♯",
          nokey2 = "",
          f_sharp = "F♯",
          g_sharp = "G♯",
          a_sharp = "A♯",
          halfkey2 = "",
          edgekey2 = ""
        ) %>% to_reactable()
      })

      output$naturals_rt <- renderReactable({
        # C -> B
        list(
          edgekey1 = "",
          halfkey1 = "",
          all_natural = "Naturals",
          halfkey2 = "",
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
          allplus_flat = "All(♭)",
          all_flat = "Flats",
          halfkey1 = "",
          d_flat = "D♭",
          e_flat = "E♭",
          nokey2 = "",
          g_flat = "G♭",
          a_flat = "A♭",
          b_flat = "B♭",
          halfkey2 = "",
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
            minWidth = k$letter_min_width,
            maxWidth = k$letter_max_width,
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
              is_all <- str_detect(name, "all")
              is_plus <- str_detect(name, "plus")
              is_widekey <- str_detect(name, "widekey")

              res <- colDef() # Default

              if (is_edgekey) {
                min_width <- iff(name == "edgekey1", 10, 15)
                res <- colDef(minWidth = min_width, maxWidth = 1000)
              }
              if (is_halfkey) {
                res <- colDef(
                  minWidth = k$letter_min_width / 2,
                  maxWidth = k$letter_max_width / 2
                )
              }
              if (is_widekey) {
                res <- colDef(
                  align = "left",
                  minWidth = k$letter_min_width * 8,
                  maxWidth = k$letter_max_width * 8,
                  style = "
                  font-family: 'Brush Script MT', cursive;
                  font-size: x-large;"
                )
              }
              if (is_key) {
                is_accidental <- str_detect(name, "sharp|flat")

                background_index <- iff(is_accidental, "accidental", "natural")
                background_index <- iff(is_plus, "all", background_index)
                text_index <- iff(is_accidental, "natural", "accidental")

                background_colour <- k$colour[[background_index]]
                text_colour <- k$colour[[text_index]]

                hover_input <- ns("letter_hover")
                click_input <- ns("letter_click")

                res <- colDef(
                  cell = function(value, rowIndex, colName) {
                    note <- letter_to_note(colName)
                    accidental <- colName %>%
                      strsplit("_") %>%
                      pluck(1, 2)
                    letter_class <- glue("letter {note}-letter {accidental}-letter")
                    as.character(tags$div(
                      style = "height: 100%; width: 100%;",
                      tags$button(
                        value,
                        class = letter_class,
                        style = paste0(
                          "--letter-background-colour:", background_colour,
                          "; --letter-text-colour: ", text_colour
                        ),
                        onmouseover =
                          sprintf(
                            'Shiny.setInputValue("%s", "%s", {priority: "event"})',
                            hover_input, colName
                          ),
                        onmouseout =
                          sprintf(
                            'Shiny.setInputValue("%s", "%s", {priority: "event"})',
                            hover_input, ""
                          ),
                        onclick =
                          sprintf(
                            'Shiny.setInputValue("%s", "%s", {priority: "event"})',
                            click_input, colName
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

      ## LEARNING --------------------------------------------------------------
      # Observe letter buttons -------------------------------------------------
      observeEvent(
        input$letter_hover,
        {
          req(!state$is_playing)
          state$letter_select <- input$letter_hover
          state$input_source <- "letter"
        }
      )

      ## PLAYING ---------------------------------------------------------------
      # > Observe letter buttons -----------------------------------------------
      observeEvent(
        input$letter_click,
        {
          req(state$is_playing)
          state$letter_select <- list(
            val = input$letter_click,
            time = Sys.time()
          )
          state$input_source <- "letter"
        }
      ) # observeEvent

      # > Display question -----------------------------------------------------
      observeEvent(
        state$question,
        {
          if (state$is_playing) {
            question <- state$question

            # Display letter when player has to choose the matching fret
            req(question$type == "note_fret")

            letter_highlight(
              session,
              question$note,
              role = "question"
            )
          }
        }
      ) # observeEvent
    } # function
  ) # moduleServer
} # letters_server
