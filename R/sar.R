# RUN APP -----------------------------------------------------------------------------------------

# Save and rerun app - easier than clicking the run button :)
sar <- function(){
  rstudioapi::documentSaveAll()
  runApp()
}
