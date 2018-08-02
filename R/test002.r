
#' test002 Sluzy do zweryfikowania sum kontrolnych z pliku JPK
#'
#' @param data must be converted to numeric data.frame with JPK FA, or JPK_VAT
#'
#' @return return list with 3 elements.
#'
#'  1. Logical TRUE, or FALSE depends on if control sums computed vs control sums from JPK file are equal,
#'
#'  2. Control sums from JPK file,
#'
#'  3. Control sums computed from 'data'
#'
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

  result_test <- F

  computedControlSums = switch(
    jpk_type,
    "JPK_VAT"="JPK_VAT is not supported yet",
    "JPK_FA"= {

    data %>%
       select(P_13_1, P_13_2, P_13_3, P_13_4, P_13_5, P_13_6, P_13_7,
              P_14_1, P_14_2, P_14_3, P_14_4, P_14_5) %>%
       mutate_all(as.numeric) %>%
       mutate(LiczbaFaktur = 1) %>%
       summarise_all(sum, na.rm = T) %>%
       mutate(WartoscFaktur = P_13_1 + P_13_2 + P_13_3 + P_13_4 + P_13_5 + P_13_6 + P_13_7 +
                P_14_1 + P_14_2 + P_14_3 + P_14_4 + P_14_5) %>%
       mutate_all(round, 2) %>%
       select(LiczbaFaktur, WartoscFaktur)
    },
    "JPK_WB"="JPK_WB is not supported yet",
    "JPK_MAG"="JPK_MAG is not supported yet"

  )
  if (identical(computedControlSums, controlSumsFromFile)) {
    result_test <- TRUE
  }
  result <- list(
    typeOfExport = "list",
    whichIndexesExport = c(3:5),
    result = tibble(result_test),
    controlSumsFromFile = controlSumsFromFile,
    computedControlSums = computedControlSums)
  return(result)
}



