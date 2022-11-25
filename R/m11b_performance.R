performance_ui <- function(id) {
  ns <- NS(id)

  div(
    id = ns("performance_div"),
    fillRow(
      flex = c(0.5, 1.2, 1, 1, 3),
      p(),
      uiOutput(ns("accuracy_kpi")),
      uiOutput(ns("games_kpi")),
      uiOutput(ns("questions_kpi")),
      uiOutput(ns("performance_chart_ui"))
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

      output$accuracy_kpi <- renderUI({
        value <- state$performance_data$accuracy
        if (!is.null(value)) value <- percent(value)
        kpi(value, "Accuracy")
      })

      output$games_kpi <- renderUI({
        value <- state$performance_data$games
        kpi(value, "Games")
      })

      output$questions_kpi <- renderUI({
        value <- state$performance_data$questions
        kpi(value, "Questions")
      })

      kpi <- function(value, description) {
        value <- value %>% if_null_then(0)

        div(
          style = "display: inline-block;",
          div(
            class = "kpi",
            p(class = "kpi__value", value),
            p(class = "kpi__description", description)
          )
        )
      }

      output$performance_chart_ui <- renderUI({
        df <- state$performance_data$chart_data

        no_data <- any(is.null(df), nrow(df) == 0)

        if (no_data) {
          return(
            div(
              style = "margin-top: 30px;",
              h4("Play a game to see your performance...")
            )
          )
        }

        echarts4rOutput(ns("performance_chart"), height = "100px", width = "40vw")
      })



      output$performance_chart <- renderEcharts4r({
        df <- state$performance_data$chart_data %T>% req()

        df %>%
          e_charts(game) %>%
          e_line(accuracy,
            animation = FALSE, symbol = NULL, color = k$colour$accuracy,
            endLabel = list(show = TRUE, formatter = "accuracy", color = k$colour$accuracy),
            labelLayout = list(moveOverlap = "shiftY")
          ) %>%
          e_line(speed,
            animation = FALSE, symbol = NULL, color = k$colour$speed,
            endLabel = list(show = TRUE, formatter = "speed", color = k$colour$speed),
            labelLayout = list(moveOverlap = "shiftY")
          ) %>%
          e_legend(show = FALSE) %>%
          e_grid(top = "0%", height = "90%") %>%
          e_x_axis(show = FALSE) %>%
          e_y_axis(show = FALSE)
      })

      # Do not suspend outputs when hidden
      c("accuracy_kpi", "games_kpi", "questions_kpi", "performance_chart") %>%
        walk(
          ~ outputOptions(output, .x, suspendWhenHidden = FALSE)
        )
    } # function
  ) # moduleServer
} # server
