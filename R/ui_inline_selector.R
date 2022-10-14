# Selector positioned inline with other elements
inline_selector <- function(id, choices, selected, width = "20vw", multiple = TRUE){
  div(
    style = paste0("display: inline-block; width: ", width, "; padding: 5px;")
    , selectizeInput(
      id        
      , label = NULL
      , choices = choices
      , selected = selected
      , multiple = multiple
      , width = width
    ) # selectizeInput
  ) #div
}
