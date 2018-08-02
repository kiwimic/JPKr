
#' test001 Służy do obliczenia sum kontrolnych.
#'
#' @param testReturn must be list which is returned after one of test fun test001, 002 ...
#'
#' @return exported file
#' @export
#'
#' @examples
testExport <- function(testReturn, export_dir) {

  if ((sum(class(testReturn) %in% c("list"))==0)) {
    stop(sprintf("testReturn needs to be class 'list', not %s", class(testReturn)))
  }

  typeOfReturn <- testReturn$typeOfExport
  indexes <- testReturn$whichIndexesExport
  jpk_type <- testReturn$jpk_type
  testName <- testReturn$testName
  filename <- paste(testName, jpk_type, sep = "_")

  result = switch(
    typeOfReturn,
    "list"= {
      writexl::write_xlsx(testReturn[indexes], path = paste0(export_dir, "/",
                                                             filename,
                                                             ".xlsx")
                          )
    },
    "text"= {


    },
    "JPK_WB"="JPK_WB is not supported yet",
    "JPK_MAG"="JPK_MAG is not supported yet"

  )
}



