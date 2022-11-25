// Selectize disable
Shiny.addCustomMessageHandler("selectize_disable", function (disable) {
  disable
    ? $(".selectized").each(function (i, obj) {
        obj.selectize.disable();
      })
    : $(".selectized").each(function (i, obj) {
        obj.selectize.enable();
      });
});

// Fret Visibility
Shiny.addCustomMessageHandler("clear_questions", function (input) {
  $(".question-note").remove();
  $(".dot").css("background", "");
  $(".letter").css("background", "");
  $(".letter").css("color", "");
});

Shiny.addCustomMessageHandler("dot_all_visibility", function (visible) {
  console.log(`dot_all_visibility ${visible}`);
  visible ? $(".dot").show() : $(".dot").hide();
});

Shiny.addCustomMessageHandler("note_all_visibility", function (visible) {
  visible ? $(".dot-text").show() : $(".dot-text").hide();
});

Shiny.addCustomMessageHandler(
  "note_visibility_by_accidental",
  function (input) {
    const letter = input.letter;
    const note_class =
      letter.length == 0
        ? `.${input.accidental}`
        : `.${input.accidental}.${input.letter}`;
    // Show grand parent (dot)
    input.visible
      ? $(note_class).parent().parent().show()
      : $(note_class).parent().parent().hide();
    // Show parent (dot-text)
    input.visible
      ? $(note_class).parent().show()
      : $(note_class).parent().hide();
    // Show me (note)
    input.visible ? $(note_class).show() : $(note_class).hide();
    // Hide siblings (alternative accidental if exists)
    $(note_class).siblings().hide();
  }
);

Shiny.addCustomMessageHandler(
  "note_visibility_by_coordinate",
  function (input) {
    const coord = `${input.coord}`;
    const dot = `${input.coord} .dot`;
    const dot_text = `${input.coord} .dot-text`;
    const natural = `${input.coord} .natural`;
    const accidental = `${input.coord} .${input.accidental}`;
    // Show dot and dot-text
    console.log(coord);
    input.visible ? $(dot).show() : $(dot).hide();
    input.visible ? $(dot_text).show() : $(dot_text).hide();
    input.visible ? $(natural).show() : $(natural).hide();
    input.visible ? $(accidental).show() : $(accidental).hide();
    $(accidental).siblings().hide();

    if (input.role != "display") {
      $(dot).css("background", input.dot_colour);
    }

    if (input.inject_text != "") {
      $(".question-note").remove();
      $(dot_text).append(
        `<span class="question-note">${input.inject_text}<span>`
      );
      $(".question-note").siblings().hide();
    }
  }
);

// Inject results into fret coordinate
Shiny.addCustomMessageHandler("add_result_to_fret", function (input) {
  const coord = `${input.coord} .rt-td-inner`;
  if (input.inject_html != "") {
    $(coord).append(input.inject_html);
  }
});

Shiny.addCustomMessageHandler("clear_game_results", function (input) {
  $(".result-note").remove();
});

// Letter visibility
Shiny.addCustomMessageHandler("Learn_letters_visibility", function (visible) {
  const letters = `.learn-letter`;
  visible ? $(letters).show() : $(letters).hide();
});

// Highlight letters
Shiny.addCustomMessageHandler("letter_add_highlight", function (input) {
  const button = `.${input.letter_class}`;
  $(button).css("background", input.highlight_colour);
  $(button).css("color", input.colour);
});

// Deactivate strings
Shiny.addCustomMessageHandler("deactivate_strings", function (strings) {
  $.each(strings, function (index, value) {
    $(value).addClass("inactive");
  });
});

// Activate strings
Shiny.addCustomMessageHandler("activate_strings", function (strings) {
  $.each(strings, function (index, value) {
    $(value).removeClass("inactive");
  });
});
