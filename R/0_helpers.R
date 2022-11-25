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

# Icon with a link
icon_link <- function(name, link) {
    a(href = link, target = "_blank", rel = "noopener noreferrer", icon(name))
}

footer_element <- function() {
    div(
        class = "footer",
        div(
            class = "footer__text-box",
            div(
                HTML("Posit Table Contest 2022 &copy; Vlad Fridkin"),
                icon_link("linkedin", "https://www.linkedin.com/in/vfridkin/"),
                icon_link("github", "https://github.com/vfridkin"),
                icon_link("youtube", "https://youtu.be/RQj60_IPf2M"),
                
            )
        )
    )
}
