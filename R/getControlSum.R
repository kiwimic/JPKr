
#' getControlSum
#'
#' @param pointer_of_file_xml Pointer to the xml file which was read with xml2::read_xml function
#' @param xPath xpath for node for example "//d1:FakturaCtrl"
#'
#' @return value
#' @export
#'
#' @examples
getControlSum <- function(pointer_of_file_xml, xPath) {
  if (sum(class(pointer_of_file_xml) %in% d2)==0) {
    stop(sprintf("pointer_of_file_xml needs to be class 'xml_document, xml_node', not %s", class(pointer_of_file_xml)))
  }
  ret <- pointer_of_file_xml %>%
    xml_find_first(xPath) %>%
    as_list() %>%
    unlist() %>%
    t() %>%
    as.tibble() %>%
    mutate_all(as.numeric)

  return(ret)
}

