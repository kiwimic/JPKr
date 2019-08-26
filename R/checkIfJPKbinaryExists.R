
#' checkIfJPKbinaryExists
#'
#'
#'
#' @return T or F
#' @export
#'
#'
checkIfJPKbinaryExists <- function(pathToBinary = Sys.getenv(x = "JPKr_GO_BINARY")) {
  file.exists(pathToBinary)
}
