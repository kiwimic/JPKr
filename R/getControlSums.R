
#' getControlSums
#'
#' @param pointer_of_file_xml Pointer to the xml file which was read with xml2::read_xml function
#' @param xPath xpath for node for example "//d1:FakturaCtrl"
#'
#' @return numeric tibble with control sums
#' @export
#'
#'
getControlSums <- function(linesOfJPK = JPK_UNKNOWN_text, pattern = JPK_CONFIG$JPK_FA$Ctrl[[1]][[1]]) {
  # if (sum(class(pointer_of_file_xml) %in% c("xml_document", "xml_node"))==0) {
  #   stop(sprintf("pointer_of_file_xml needs to be class 'xml_document, xml_node', not %s", class(pointer_of_file_xml)))
  # }
    linesOfJPK %>%
      grep(pattern = pattern) -> indexCTRL_st_i_kc

      paste(linesOfJPK[c(indexCTRL_st_i_kc[1]:indexCTRL_st_i_kc[2])], collapse = "\n") %>%
      read_xml(encoding = "UTF-8") %>%
      as_list() %>%
      unlist() %>%
      t() %>%
      as.tibble() %>%
      mutate_all(as.numeric) -> data

      colnames(data) <- gsub(colnames(data), pattern = pattern, replacement = "")
      colnames(data) <- gsub(colnames(data), pattern = "\\.", replacement = "")

      return(data)
}

