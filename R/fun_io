# DATA I/O ----------------------------------------------------------------------------------------

to_local_storage_id <- function(id) {
    paste0(ac$local_storage_id_prefix, id)
}

set_local_storage <- function(id, data, session) {
    ls_id <- id %>% to_local_storage_id()
    json_string <- data %>%
        toJSON() %>%
        toString()
    session$sendCustomMessage("set_local_storage", list(id = ls_id, data = json_string))
}

get_local_storage <- function(id, session) {
    ls_id <- id %>% to_local_storage_id()
    session$sendCustomMessage("get_local_storage", ls_id)
}

get_local_storage_multi <- function(ids, session) {
    ls_ids <- ids %>% map(to_local_storage_id)
    session$sendCustomMessage("get_local_storage_multi", ls_ids)
}

remove_local_storage <- function(id, session) {
    ls_id <- id %>% to_local_storage_id()
    session$sendCustomMessage("remove_local_storage", ls_id)
}