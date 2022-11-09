#' Create a transport button
transport_button <- function(id, icon_name, style = "", color = "primary", width = "40px"){
  div(
    style = "display: inline-block; padding: 5px;"
    , actionButton(
      id
      , label = NULL
      , style = style
      , icon = icon(icon_name)
      , width = width
    )
  ) # div
}