# App configuration
load_config <- function(){
  
  config <- read_yaml("config/config.yaml")
  
  game_df <- fread("config/game.csv")
  range_df <- fread("config/range.csv")

  config %>%
    list_modify(
      game = game_df
      , range = range_df
    )
}
