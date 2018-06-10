

#' Title
#'
#' @param JPK_UNKNOWN
#'
#' @return
#' @export
#'
#' @examples
guessJpkType <- function(JPK_UNKNOWN) {

  JPK_UNKNOWN %>%
    xml_find_first("//d1:Naglowek") %>%
    as_list() %>%
    unlist() %>%
    t() %>%
    as.tibble() %>%
    select(KodFormularza) %>%
    unlist() %>%
    unname()

  return(TYP_PLIKU)
}
