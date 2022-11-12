add_fret_markers <- function(df) {
    fn <- function(x) paste0("<span class='fret-marker'></span>", x)
    fn2 <- function(x) paste0("<span class='fret-marker2'></span>", x)

    cols <- paste0("fret", c(3, 5, 7, 9))

    # Markers are split between vertically adjacent divs

    # Top half of markers
    df[3, (cols) := lapply(.SD, fn), .SDcols = cols]
    df[c(2, 4), fret12 := fn(fret12)]

    # Bottom half of markers
    df[4, (cols) := lapply(.SD, fn2), .SDcols = cols]
    df[c(3, 5), fret12 := fn2(fret12)]

    df
}

#' Convert fret selection to display format
#' @param fret_select list(row = {row}, col = {col_name})
#' @return {name}_{accidental}
display_from_fret <- function(fret_select, accidental = "sharp") {
    name <- fret_select$col
    display <- iff(
        name == "none",
        "", glue("{name}_{accidental}")
    )

    list(
        rows = fret_select$row,
        display = display
    )
}

#' Column definitions for frets
get_fret_col_def <- function(fret_count) {
    headstock_coldef <- list(
        fret0 = colDef(
            name = "",
            class = function(value, index, name) {
                paste("headstock-string fretcell", index, name)
            },
            style = function(value, index, name) {
                paste0(
                    "position: relative;
          --thickness: ", k$string_thickness[index], "px;
          --rotation: ", k$string_rotation[index], "deg;
          "
                )
            }
        )
    )

    fret_names <- paste0("fret", 1:k$fret_count)

    fret_min_width <- function(fret) {
        round(50 * (1 - fret / 24))
    }

    frets_coldef <- 1:k$fret_count %>%
        map(
            function(fret) {
                colDef(
                    name = "",
                    minWidth = fret_min_width(fret),
                    html = TRUE,
                    align = "center",
                    class = function(value, index, name) {
                        paste("guitar-string fretcell", index, name)
                    },
                    style = function(value, index, name) {
                        paste0(
                            "position: relative; --thickness: ", k$string_thickness[index], "px;"
                        )
                    }
                )
            }
        ) %>%
        set_names(fret_names)

    c(headstock_coldef, frets_coldef)
}
