performance_ui <- function(id) {
  ns <- NS(id)

  div(
    id = ns("performance_div"),
    fillRow(
      flex = c(1.2, 1, 1, 3),
      uiOutput(ns("accuracy_kpi")),
      uiOutput(ns("games_kpi")),
      uiOutput(ns("questions_kpi")),
      echarts4rOutput(ns("performance_chart"), height = "100px", width = "40vw")
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
        state$saved_log,
        {
          df <- state$saved_log

          no_saved_data <- any(is.null(df), nrow(df) == 0)

          if (no_saved_data) {
            return(
              list(
                chart_data = NULL,
                accuracy = 0,
                games = 0,
                questions = 0
              )
            )
          }

          # Questions
          questions <- nrow(df)

          # Chart data
          chart_data <- df[
            , .(
              accuracy = sum(correct) / .N,
              speed = max(play_time) / .N
            ),
            by = start_time
          ][, game := .I]

          # Accuracy
          accuracy <- sum(df$correct) / questions

          # Games
          games <- max(chart_data$game)

          list(
            chart_data = chart_data,
            accuracy = accuracy,
            games = games,
            questions = questions
          )
        }
      )

      output$accuracy_kpi <- renderUI({
        value <- pdata()$accuracy %>% percent()
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

      kpi <- function(value, description) {
        div(
          style = "display: inline-block;",
          div(
            class = "kpi",
            p(class = "kpi__value", value),
            p(class = "kpi__description", description)
          )
        )
      }

      output$performance_chart <- renderEcharts4r({
        message("render chart")

        df <- pdata()$chart_data

        df %>%
          e_charts(game) %>%
          e_line(accuracy,
            animation = FALSE, symbol = NULL, color = "green",
            endLabel = list(show = TRUE, formatter = "accuracy", color = "green"),
            labelLayout = list(moveOverlap = "shiftY")
          ) %>%
          e_line(speed,
            animation = FALSE, symbol = NULL, color = "blue",
            endLabel = list(show = TRUE, formatter = "speed", color = "blue"),
            labelLayout = list(moveOverlap = "shiftY")
          ) %>%
          e_legend(show = FALSE) %>%
          e_grid(top = "0%", height = "90%") %>%
          e_x_axis(show = FALSE) %>%
          e_y_axis(show = FALSE)
      })

      # Do not suspect outputs when hidden
      c("accuracy_kpi", "games_kpi", "questions_kpi", "performance_chart") %>%
        walk(
          ~ outputOptions(output, .x, suspendWhenHidden = FALSE)
        )
    } # function
  ) # moduleServer
} # server
