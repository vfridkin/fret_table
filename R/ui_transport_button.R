#' Create a transport button
transport_button <- function(id, icon_name, style = "simple", color = "primary"){
  div(
    style = "display: inline-block; padding: 5px;"
    , actionBttn(
      id
      , style = style
      , color = color
      , icon = icon(icon_name)
    )
  ) # div
}