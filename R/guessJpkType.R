

#' getJpkType
#'
#' @param pointer_of_file_xml
#'
#' @return type of JPK file like 'JPK_FA', 'JPK_VAT3'
#' @export
#'
#' @examples
getJpkType <- function(pointer_of_file_xml) {
  if (sum(class(pointer_of_file_xml) %in% c("xml_document", "xml_node"))==0) {
    stop(sprintf("pointer_of_file_xml needs to be class 'xml_document, xml_node', not %s", class(pointer_of_file_xml)))
  }
  pointer_of_file_xml %>%
    xml_find_first("//d1:Naglowek") %>%
    as_list() %>%
    unlist() %>%
    t() %>%
    as.tibble() %>%
    select(KodFormularza) %>%
    unlist() %>%
    unname() -> TYP_PLIKU

  return(TYP_PLIKU)
}
