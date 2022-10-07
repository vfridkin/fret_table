control_ui <- function(id){
  
  ns <- NS(id)
  
  transport_button <- function(id, icon_name, style = "simple", color = "primary"){
    div(
      style = "display: inline; padding: 5px;"
      , actionBttn(
        id
        , style = style
        , color = color
        , icon = icon(icon_name)
      )
    ) # div
  }
  
  tagList(
    fluidRow(
      style = "padding: 10px;"
      , column(
        width = 12
        , transport_button(ns("setting_button"), "bars", style = "bordered")
        , transport_button(ns("play_button"), "play")
        , transport_button(ns("pause_button"), "pause", color = "warning")
        , transport_button(ns("stop_button"), "stop", color = "danger")
        , div(
          style = "display: inline; padding: 5px;"
          , selectizeInput(
            ns("game_select")
            , label = NULL
            # , label = span(style = "font-size: x-small;", "game")
            , choices = ac$game$id
            , selected = ac$game$id[1]
          ) # selectizeInput
        ) #div
      )
    )
  )
  
  
}

control_server <- function(id, k_, r_ = reactive(NULL)){
  moduleServer(
    id
    , function(input, output, session){
      
      ns <- session$ns
      
      
    } # function
  ) # moduleServer
} # control_server