
#' test002 Służy do zweryfikowania sum kontrolnych z pliku JPK
#'
#' @param data must be converted to numeric data.frame with JPK FA, or JPK_VAT
#'
#' @return return list with 3 elements.
#'  1. Logical TRUE, or FALSE depends on if control sums computed vs control sums from JPK file are equal,
#'  2. Control sums from JPK file,
#'  3. Control sums computed from 'data'
#' @export
#'
#' @examples
test002 <- function(data = NA, controlSumsFromFile = NA, jpk_type = NA) {
  if (is.na(jpk_type)) {
    stop(sprintf("please pass jpk_type argument in test002 function"))
  }
  if ((sum(class(data) %in% c("data.frame", "tibble", "tbl_df"))==0)) {
    stop(sprintf("data needs to be class 'data.frame, tibble, tbl_df', not %s", class(data)))
  }
  if ((sum(class(controlSumsFromFile) %in% c("data.frame", "tibble", "tbl_df"))==0)) {
    stop(sprintf("controlSumsFromFile needs to be class 'data.frame, tibble, tbl_df', not %s", class(controlSumsFromFile)))
  }

  computedControlSums = switch(
    jpk_type,
    "JPK_VAT"="Good Morning",
    "JPK_FA"= {
      data %>%
        group_by(Species) %>%
        summarise(N = n())

    },
    "JPK_WB"="Good Evening",
    "JPK_MAG"="Good Night"

  )

  result <- list(result = FALSE,
                 controlSumsFromFile = controlSumsFromFile,
                 computedControlSums = computedControlSums)
  return(result)
}
