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
