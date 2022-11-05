main_ui <- function(id) {
  ns <- NS(id)

  tagList(
    control_ui(ns("control")),
    fretboard_ui(ns("fretboard"))
  )
}

main_server <- function(id, k_) {
  moduleServer(
    id,
    function(input, output, session) {
      ns <- session$ns

      control_server("control", "k_")
      fretboard_server("fretboard", "k_")
    } # function
  ) # moduleServer
} # main_server
