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
        style = "display: inline-block; width: -webkit-calc(100vw - 135px); height: 50px;"
        , fillRow(
            flex = c(1, 5, 3, 3)
            , transport_button(ns("setting_button"), "bars", style = "bordered")
            , inline_selector(ns("game_select"), game_choices, game_selected, width = "100%")
            , inline_selector(ns("range_select"), range_choices, range_selected, width = "100%")
            , inline_selector(ns("turns_select"), turns_choices, turns_selected, width = "100%", multiple = FALSE)
        ) # fluidRow
        , fillRow(
            div(
              style = "width: 200px;"
              , transport_button(ns("play_button"), "play")
              , transport_button(ns("pause_button"), "pause", color = "warning")
              , transport_button(ns("stop_button"), "stop", color = "danger")
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