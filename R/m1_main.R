main_ui <- function(id) {
  ns <- NS(id)

  tagList(
    div(
      style = "text-align: center; margin-top: 40px;",
      class = "header__text-box",
      h1(
        style = "
          font-family: 'Brush Script MT',
          cursive; font-size: 90px;",
        "Fret Table🎸"
      )
    ),
    div(
      style = "
        display: inline-block;
        margin-top: 5px;
        height: 100px;
        width: -webkit-calc(100vw - 160px);
      ",
      control_ui(ns("control")),
      performance_ui(ns("performance")),
    ),
    div(
      id = ns("plectrum"),
      style = "
          display: inline-block;
          width: 70px;
          vertical-align: top;
          margin-left: -20px
        ",
      img(
        height = 100,
        src = "plectrum.png",
        alt = "My Performance Image"
      )
    ), # div
    fretboard_ui(ns("fretboard")),
    letters_ui(ns("letters")),
    footer_element()
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
      performance_server("performance", "k_")
    } # function
  ) # moduleServer
} # main_server
