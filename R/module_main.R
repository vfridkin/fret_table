main_ui <- function(id){
  
  ns <- NS(id)
  
  tagList(
    control_ui("control")
  )
  
  
}

main_server <- function(id, k_){
  moduleServer(
    id
    , function(input, output, session){

      ns <- session$ns

      control_server("control", "k_")      
      
      
    } # function
  ) # moduleServer
} # main_server