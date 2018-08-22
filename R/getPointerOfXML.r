

#' getPointerOfXML xml2::read_xml(x = file_xml)
#'
#' @param file_xml
#'
#' @return pointer to xml file
#'
#'
#' @export
getPointerOfXML <- function(file_xml = "") {
  readit <- NULL
  if (!is.character(file_xml)|is.na(file_xml)) {
    stop("You have to pass path to xml file")
  } else {
    readit <- xml2::read_xml(x = file_xml)
  }


return(readit)
}
