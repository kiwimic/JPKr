

#' readJPKtoMemory reads file as list no parsing is done.
#'
#' @param file_xml
#'
#' @return only non-parsed list
#'
#'
#'
readJPKtoMemory <- function(file_xml = "") {
  readit <- xml2::read_xml(x = file_xml) %>%
    as_list()

return(readit)
}
