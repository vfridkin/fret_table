iff <- function(bool_case, true_option, false_option) {
    if (bool_case) true_option else false_option
}

if_null_then <- function(val, replace_if_null) {
    iff(is.null(val), replace_if_null, val)
}

get_answer_html <- function(answer, colour, prefix = "") {
    val <- list(
        "TRUE" = "♪",
        "FALSE" = "×"
    )[[answer]]

    glue("
        <span style = 'color: {colour}; padding: 0;'>
            {prefix}{val}
        </span>
    ") %>% as.character()
}
