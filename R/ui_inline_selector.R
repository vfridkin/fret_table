# Selector positioned inline with other elements
inline_selector <- function(id, choices, selected, width = 200, multiple = TRUE){
  div(
    style = paste0("display: inline-block; width: ", width + 10,"px; padding: 5px;")
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
