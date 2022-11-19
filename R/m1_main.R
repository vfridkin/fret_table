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
        height = 115,
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

      observeEvent(
        input$local_storage,
        {
          log <- input$local_storage
          no_log <- is.null(log)

          # If log doesn't exist, create a new one
          if (no_log) {
            log <- create_new_log()
          }
          log <- log %>%
            map(fromJSON) %>%
            pluck(1) %>%
            setDT()

          # Time column class
          log[, start_time := as.POSIXct(start_time)]

          state$saved_log <- log
        }
      )

      control_server("control", "k_")
      fretboard_server("fretboard", "k_")
      letters_server("letters", "k_")
      performance_server("performance", "k_")
    } # function
  ) # moduleServer
} # main_server
