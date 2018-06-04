#' Test_ValidateControlSums test if two values are equal with '==' and returns error, or warning. This depends form onlyWarning param
#'
#' @param V1 First value - scalar
#' @param V2 Second value - scalar
#' @param msg Message formated to sprintf function
#' @param onlyWarning param to choose if user want to only warn or error. Warning allows funcion to finish, error stops function
#'
#' @return error or warning with msg
#'
#'
#' @seealso \code{\link{sprintf}}
Test_ValidateControlSums <- function(V1, V2, msg, onlyWarning = F) {
  if (V1 != V2) {
    if (onlyWarning) {
      warning(sprintf(msg, V1, V2))
    } else {
      stop(sprintf(msg, V1, V2))
    }
  }
}

