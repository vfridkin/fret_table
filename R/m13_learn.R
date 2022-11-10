learn_ui <- function(id) {
  ns <- NS(id)

  learn_choices <- ac$range$id %>% set_names(ac$range$name)
  learn_selected <- ac$range[default == 1]$id

  # learn choices

  tagList(
    div(style = "margin-top: 5px;"),
    div(
      style = "
        display: inline-block;
        width: -webkit-calc(100vw - 280px);
        height: 30px;
        ",
      fluidRow(
        column(
          width = 3,
          h3(
            style = "
            font-family: 'Brush Script MT', cursive;
            margin-bottom: -10px;
            padding-left: 10px;",
            "Learn"
          ),
          inline_selector(ns("learn_select"),
            learn_choices, learn_selected,
            width = "100%"
          )
        )
      ) # Row
    ) # div
  ) # tagList
}

learn_server <- function(id, k_, r_ = reactive(NULL)) {
  moduleServer(
    id,
    function(input, output, session) {
      ns <- session$ns

      m <- reactiveValues(
        run_once = TRUE,
        learn_select = NULL
      )
    } # function
  ) # moduleServer
} # control_server
