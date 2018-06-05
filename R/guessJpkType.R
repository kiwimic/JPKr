

#' Title
#'
#' @param JPK_UNKNOWN
#'
#' @return
#' @export
#'
#' @examples
guessJpkType <- function(JPK_UNKNOWN) {
   JPK_UNKNOWN <- JPK_UNKNOWN[["JPK"]]

   TYP_PLIKU <- JPK_UNKNOWN["Naglowek"] %>%
    unname() %>%
    unlist() %>%
    t() %>%
    as.tibble() %>%
    select(KodFormularza) %>%
    unlist() %>%
    unname()

  return(TYP_PLIKU)
}
