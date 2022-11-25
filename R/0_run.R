# RUN APP ----------------------------------------------------------------------

# Save and rerun app - RStudio
sar <- function() {
  rstudioapi::documentSaveAll()
  runApp()
}

# Run app from vscode
vsar <- function() {
  source("global.R")
  rstudioapi::documentSaveAll()
  app_dir <- "C:/Users/vfrid/Documents/R_projects//fret_table"
  # app_dir <- "C:/Users/vladi/Documents/R/fret_table"
  runApp(app_dir, launch.browser = TRUE)
}
