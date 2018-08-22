
#' getJpkType
#'
#' @param pointer_of_file_xml
#'
#' @return character vector with type of JPK file like 'JPK_FA', 'JPK_VAT'
#' @export
#'
#'
getJpkType <- function(pointer_of_file_xml) {
  if (sum(class(pointer_of_file_xml) %in% c("xml_document", "xml_node"))==0) {
    stop(sprintf("pointer_of_file_xml needs to be class 'xml_document, xml_node', not %s", class(pointer_of_file_xml)))
  }

 ret <- tryCatch({
    pointer_of_file_xml %>%
      xml_find_first("//d1:Naglowek") %>%
      as_list() %>%
      unlist() %>%
      t() %>%
      as.tibble() %>%
      select(KodFormularza) %>%
      unlist() %>%
      unname() -> typJPK

    return(typJPK)},
    warning = function(w) {
     pointer_of_file_xml %>%
        xml_find_first("/tns:JPK/tns:Naglowek") %>%
        as_list() %>%
        unlist() %>%
        t() %>%
        as.tibble() %>%
        select(KodFormularza) %>%
        unlist() %>%
        unname() -> typJPK
      return(typJPK)
    },
    error = function(e) {
      print(paste("X is no pointer to the JPK xml file", x))

      NULL
    }
  )
 return(ret)
}
