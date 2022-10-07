# User interface main file

# 888     888 8888888     8888888b.
# 888     888   888       888   Y88b
# 888     888   888       888    888
# 888     888   888       888   d88P
# 888     888   888       8888888P"
# 888     888   888       888 T88b
# Y88b. .d88P   888   d8b 888  T88b
#  "Y88888P"  8888888 Y8P 888   T88b

###################################################################################################
#
# -= Welcome to Fret Table =-
#
# Modules
# > main - the main screen of the app
# > control - the control bar at the top of the app
# > fret - the guitar fret in the middle (using reactable)
# v note - the note name buttons below (using reactables)
# > setting - app settings
# > help 
#
# Summary of design
# ~~~~~~~~~~~~~~~~~
# Configuration is controlled from YAML and CSV files.
# Local storage is used to save user changes.
# ui.R and server.R contain main ui and server.
# main contains all the other modules
#
# Thanks for reading and hope you enjoy the app, Vlad Fridkin 2022
#
###################################################################################################

fluidPage(
  
  # CSS and JS files - for animation, styling and custom interactions
  load_styles()
  # , includeScript("www/script.js")
  
  # Tour dependency
  , introjsUI()
  
  # Main
  , main_ui("main")
  
)
