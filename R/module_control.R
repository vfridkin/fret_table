control_ui <- function(id){
  
  ns <- NS(id)
  
  game_choices <- ac$game$id %>% set_names(ac$game$name)
  game_selected <- ac$game[default == 1]$id
  
  range_choices <- ac$range$id %>% set_names(ac$range$name)
  range_selected <- ac$range[default == 1]$id
  
  turns_choices <- c(5, 10, 20) %>% set_names(paste(., "turns"))
  turns_selected <- 10
  
  # TODO: Split into two rows, with transport on bottom and right image across both rows
  # Score is on bottom after the transport.
  
  tagList(
    div(
      style = "display: inline-block; width: 90px; vertical-align: top; padding-top: 5px;"       
      , transport_button(ns("play_button"), "play", width = "80px"
                         , style = "height: 80px; font-size: xx-large; color: #f5ebe0; background-color: #06d6a0;")
    )
    , div(
      style = "display: inline-block; width: 50px; vertical-align: top; padding-top: 5px;"      
      , transport_button(ns("setting_button"), "info", style = "height: 35px; color: #f5ebe0; background-color: #073b4c; font-size: larger;")
      , transport_button(ns("stop_button"), "stop", style = "height: 35px; color: #f5ebe0; background-color: #ef476f;")  # Pause: #ffd166
    )
    , div(
      style = "display: inline-block; width: -webkit-calc(100vw - 280px); height: 50px;"
      , fillRow(
        flex = c(5, 3, 3)
        , inline_selector(ns("game_select"), game_choices, game_selected, width = "100%")
        , inline_selector(ns("range_select"), range_choices, range_selected, width = "100%")
        , inline_selector(ns("turns_select"), turns_choices, turns_selected, width = "100%", multiple = FALSE)
      ) # fluidRow
      , fillRow(
        div(
          style = "width: 200px;"
        )
      ) # fluidRow
    ) # div
    , div(
      style = "display: inline-block; width: 80px; vertical-align: top; margin-left: 10px"
      , img(
        height = 100
        , src = "pick_achu.png"
        , alt = "Opponent image"
      )
    ) # div
  ) # tagList
  
}

control_server <- function(id, k_, r_ = reactive(NULL)){
  moduleServer(
    id
    , function(input, output, session){
      
      ns <- session$ns
      
    } # function
  ) # moduleServer
} # control_server