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
      Shiny.setInputValue("main-fretboard-fret_cell_hover", "-1 none", {
        priority: "event",
      });
    }
  });

  // $("body").on("mouseout", function (event) {
  //   const fret_board = event.target.closest("#main-fretboard-fretboard_rt");

  //   if (fret_board) {
  // Shiny.setInputValue("main-fretboard-fret_cell_hover", "-1 none", {
  //   priority: "event",
  // });
  //   }
  // });
});
