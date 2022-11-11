main_ui <- function(id) {
  ns <- NS(id)

  tagList(
    div(
      style = "text-align: center;",
      h1(style = "font-family: 'Brush Script MT', cursive;", "Fret Table🎸")
    ),
    control_ui(ns("control")),
    fretboard_ui(ns("fretboard")),
    letters_ui(ns("letters"))
  )
}

main_server <- function(id, k_) {
  moduleServer(
    id,
    function(input, output, session) {
      ns <- session$ns

      control_server("control", "k_")
      fretboard_server("fretboard", "k_")
      letters_server("letters", "k_")
    } # function
  ) # moduleServer
} # main_server
