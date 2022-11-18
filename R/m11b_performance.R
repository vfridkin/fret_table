performance_ui <- function(id) {
  ns <- NS(id)
  
  div(
    id = ns("performance_div"),
    fillRow(
      flex = c(1.2, 1, 1, 3),
      uiOutput(ns("accuracy_kpi")),
      uiOutput(ns("games_kpi")),
      uiOutput(ns("questions_kpi")),
      # style = "display: inline-block; width: 50vw; height: 400px;",
      echarts4rOutput(ns("performance_chart"), height = "100px")
    )
  )
}

performance_server <- function(id, k_, r_ = reactive(NULL)) {
  moduleServer(
    id,
    function(input, output, session) {
      ns <- session$ns
      
      m <- reactiveValues(
        run_once = FALSE,
        log_record = NULL
      )
      
      pdata <- eventReactive(
        state$saved_log
        , {
          df <- state$saved_log
          
          no_saved_data <- any(is.null(df), nrow(df) == 0)
          
          if(no_saved_data){
            return(
              list(
                chart_data = NULL
                , accuracy = 0
                , games = 0
                , questions = 0
              )
            )
          }
          
          browser()
          
        }
      )
      
      
      output$accuracy_kpi <- renderUI({
        value <- pdata()$accuracy %>% paste0("%")
        kpi(value, "Accuracy")
      })
      
      output$games_kpi <- renderUI({
        value <- pdata()$games
        kpi(value, "Games")
      })
      
      output$questions_kpi <- renderUI({
        value <- pdata()$questions 
        kpi(value, "Questions")
      })
      
      kpi <- function(value, description){
        div(
          style = "display: inline-block;"
          , div(
            class = "kpi"
            , p(class = "kpi__value", value)
            , p(class = "kpi__description", description)
          )              
        )
      }
      
      
      my_data <- eventReactive(
        input$plectrum,
        {
          message("chart data")
          data.frame(
            x = seq(100),
            y = rnorm(100, 10, 3),
            z = rnorm(100, 11, 2),
            w = rnorm(100, 9, 2)
          )
        },
        ignoreNULL = FALSE
      )
      
      output$performance_chart <- renderEcharts4r({
        message("render chart")
        my_data() %>%
          e_charts(x) %>%
          e_line(z,
                 animation = FALSE, symbol = NULL, color = "green",
                 endLabel = list(show = TRUE, formatter = "accuracy", color = "green"),
                 labelLayout = list(moveOverlap = "shiftY")
          ) %>%
          e_line(y,
                 animation = FALSE, symbol = NULL, color = "red",
                 endLabel = list(show = TRUE, formatter = "speed", color = "red"),
                 labelLayout = list(moveOverlap = "shiftY")
          ) %>%
          e_legend(show = FALSE) %>%
          e_grid(top = "0%", height = "90%") %>%
          e_x_axis(show = FALSE) %>%
          e_y_axis(show = FALSE)
      })
    } # function
  ) # moduleServer
} # server
