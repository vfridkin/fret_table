"use strict";

$(function () {
  // Click
  $("body").on("click", function (event) {
    const plectrum = event.target.closest("#main-plectrum");

    if (plectrum) {
      $("#main-control-control_div").toggle();
      $("#main-performance-performance_div").toggle();
    }
  }); // click

  // Mouse over
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
  }); // mouse over
});
