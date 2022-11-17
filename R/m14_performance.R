performance_ui <- function(id) {
    ns <- NS(id)

    div(
        id = ns("performance_div"),
        style = "margin-top: 0px; width: 100vw; padding: 1vw;",
        echarts4rOutput(ns("performance_chart"))
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

            output$performance_chart <- renderEcharts4r({
                df <- data.frame(
                    x = seq(50),
                    y = rnorm(50, 10, 3),
                    z = rnorm(50, 11, 2),
                    w = rnorm(50, 9, 2)
                )

                df |>
                    e_charts(x) |>
                    e_line(z) |>
                    e_area(w) |>
                    e_title("Line and area charts")
            })
        } # function
    ) # moduleServer
} # server
