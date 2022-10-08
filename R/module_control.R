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
    fluidRow(
      style = "padding: 10px;"
      , column(
        width = 12
        , transport_button(ns("setting_button"), "bars", style = "bordered")
        , transport_button(ns("play_button"), "play")
        , transport_button(ns("pause_button"), "pause", color = "warning")
        , transport_button(ns("stop_button"), "stop", color = "danger")
        , inline_selector(ns("game_select"), game_choices, game_selected, width = 300)
        , inline_selector(ns("range_select"), range_choices, range_selected)
        , inline_selector(ns("turns_select"), turns_choices, turns_selected, width = 100, multiple = FALSE)
        , div(
          style = "display: inline-block; width: 100px; height: 100px;"
          , img(
            height = 100
            , src = "pick_achu.png"
            , alt = "Opponent image"
          )
        )
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