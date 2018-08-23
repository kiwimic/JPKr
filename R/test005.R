
#' parseInvoiceNumbers
#' Sluzy do zweryfikowania czy sa luki w fakturach
#' #'
#' @param data must be vector with invoice numbers
#'
#' @return list with reports
#'
#'
#' @export
test005 <- function(data) {

  FakturyPrzygotowane <- parseInvoiceNumbers(data = data)
  dataToAnalyze <- FakturyPrzygotowane$dataToAnalyze
  patternToMatch <- FakturyPrzygotowane$pattern
  NieAnalizowane <- tibble(NieAnalizowaneNumery = FakturyPrzygotowane$undetected)
  getGapsReport(patternToMatch = patternToMatch, data = dataToAnalyze) -> RaportLuk
  RaportLuk[["Nieanalizowane"]] <- NieAnalizowane


  ret <- list(
    typeOfExport = "list",
    testName = "test005",
    export = RaportLuk
  )
  return(ret)
}
