k <- tibble::lst(
  colour = list(
    button_text = "#f5ebe0",
    button_play = "#06d6a0",
    button_info = "#073b4c",
    button_stop = "#ef476f",
    button_pause = "#ffd166",
    natural = "#f5f2e7",
    natural_darker = "#d9cea4",
    natural_lighter = "#ffffff",
    accidental = "#202020",
    accidental_darker = "#1a1a1a",
    accidental_lighter = "#282828",
    all = "#8B8984",
    display = "#8B8984",
    question = "#ffd166",
    right = "#06d6a0",
    wrong = "#ef476f"
  ),
  notes = c("C", "x", "D", "x", "E", "F", "x", "G", "x", "A", "x", "B"),
  default_accidental_choices = set_names(c("sharp", "flat"), c("♯", "♭")),
  string_count = 6,
  fret_count = 12,
  fret_names = paste0("fret", 0:fret_count),
  open_notes = c("E", "A", "D", "G", "B", "E") %>% rev(),
  string_thickness = c(1, 1, 2, 2, 3, 4),
  string_rotation = c(0, 1, 2, -2, -1, 0),
  answer_html <- list(
    "TRUE" = glue("
          <span style = '
          color: {colour$button_info};
          padding: 0;
          '>♪</span>"),
    "FALSE" = glue("
          <span style = '
            color: {colour$button_stop};
            padding: 0;
          '>×</span>")
  )
)
