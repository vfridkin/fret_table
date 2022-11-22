# User interface main file

# 888     888 8888888     8888888b.
# 888     888   888       888   Y88b
# 888     888   888       888    888
# 888     888   888       888   d88P
# 888     888   888       8888888P"
# 888     888   888       888 T88b
# Y88b. .d88P   888   d8b 888  T88b
#  "Y88888P"  8888888 Y8P 888   T88b

################################################################################
#
# -= Welcome to Fret Table =-
#
# Modules
# > m1_main - the main screen of the app
# > m11a_control - the control bar at the top of the app
# > m11b_performance - performance kpi and accuracy/speed chart
# > m12_fretboard - the guitar fret in the middle (using reactable)
# > m13_letters - the note name buttons below (using reactables)
# > m14_info - app information and settings
#
# Summary of design
# ~~~~~~~~~~~~~~~~~
# Configuration is controlled from YAML and CSV files.
# Local storage is used to save user changes.
#
# Thanks for reading and hope you enjoy the app, Vlad Fridkin 2022
#
################################################################################

fluidPage(
  # CSS and JS files
  load_styles(),
  load_scripts(),
  # Tour dependency
  introjsUI(),
  # Main
  main_ui("main")
)
