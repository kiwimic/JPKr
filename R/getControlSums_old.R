
#' getControlSums_old
#'
#' @param pointer_of_file_xml Pointer to the xml file which was read with xml2::read_xml function
#' @param xPath xpath for node for example "//d1:FakturaCtrl"
#'
#' @return numeric tibble with control sums
#' @export
#'
#' @examples
getControlSums_old <- function(pointer_of_file_xml, xPath) {
  if (sum(class(pointer_of_file_xml) %in% c("xml_document", "xml_node"))==0) {
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

