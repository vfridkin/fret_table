# RUN APP ----------------------------------------------------------------------

# Save and rerun app - RStudio
sar <- function() {
  rstudioapi::documentSaveAll()
  runApp()
}

# Run app from vscode
vsar <- function() {
  source("global.R")
  app_dir <- "C:/Users/vfrid/Documents/R_projects//fret_table"
  runApp(app_dir, launch.browser = TRUE)
}
