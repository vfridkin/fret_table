letters_ui <- function(id) {
  ns <- NS(id)

  tagList(
    fillRow() # Row
  ) # tagList
}

letters_server <- function(id, k_, r_ = reactive(NULL)) {
  moduleServer(
    id,
    function(input, output, session) {
      ns <- session$ns

      m <- reactiveValues(
        run_once = TRUE
      )
    } # function
  ) # moduleServer
} # letters_server
