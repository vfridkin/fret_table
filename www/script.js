"use strict";

$(function () {
  $("body").on("mouseover", function (event) {
    const fret_cell = event.target.closest(".fretcell.rt-td");

    if (fret_cell) {
      const fret_class = $(fret_cell).attr("class");
      Shiny.setInputValue("main-fretboard-fret_cell_hover", fret_class, {
        priority: "event",
      });
    } else {
      Shiny.setInputValue("main-fretboard-fret_cell_hover", "none none", {
        priority: "event",
      });
    }
  });
});

// Visibility
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

Shiny.addCustomMessageHandler("clear_questions", function (input) {
  $(".question-note").remove();
  $(".dot").css("background", "");
});
