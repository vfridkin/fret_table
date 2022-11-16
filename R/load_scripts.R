#' Load style sheets 
load_scripts <- function(){
  div(
    includeScript("www/main.js"),
    includeScript("www/local_storage.js"),
    includeScript("www/visibility.js")
  )
}