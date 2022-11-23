k <- tibble::lst(
  colour = list(
    fretboard = "#7c5e32",
    headstock = "#e59317",
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
    wrong = "#ef476f",
    nothing = "#D3D3D3",
    accuracy = "#06d6a0",
    speed = "#d6a006"
  ),
  default_turns = 5,
  max_saved_games = 100,
  notes = c("C", "x", "D", "x", "E", "F", "x", "G", "x", "A", "x", "B"),
  completed_action_choices = set_names(c("play", "learn"), c("Play again", "Learn")),
  default_audio_choices = set_names(c("on", "off"), c("🔊", "🔇")),
  default_accidental_choices = set_names(c("sharp", "flat"), c("♯", "♭")), # ⊘
  string_count = 6,
  fret_count = 12,
  fret_names = paste0("fret", 0:fret_count),
  open_notes = c("E", "A", "D", "G", "B", "E") %>% rev(),
  open_octaves = c(2, 2, 3, 3, 3, 4) %>% rev(),
  string_thickness = c(1, 1, 2, 2, 3, 4),
  string_rotation = c(0, 1, 2, -2, -1, 0),
  answer_html = list(
    "TRUE" = get_answer_html("TRUE", colour$right),
    "FALSE" = get_answer_html("FALSE", colour$wrong)
  ),
  letter_min_width = 70,
  letter_max_width = 120
)
