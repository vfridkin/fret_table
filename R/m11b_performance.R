performance_ui <- function(id) {
    ns <- NS(id)

    div(
        id = ns("performance_div"),
        fillRow(
            flex = c(3, 3),
            p("Test"),
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
