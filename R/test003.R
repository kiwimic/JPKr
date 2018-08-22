
#' test003 Sluzy do zweryfikowania koncentracji dla danego NIP z pliku JPK
#'
#' @param data must be converted to numeric data.frame with JPK FA, or JPK_VAT
#'
#' @return return tibble with summarise of values, counts, max, min, of documents for one NIP
#'
#'
#' @export
#'
#'
test003 <- function(data = NA, tableName = NA) {
  if (is.na(jpk_type)) {
    stop(sprintf("please pass tableName argument in test003 function"))
  }
  if ((sum(class(data) %in% c("data.frame", "tibble", "tbl_df"))==0)) {
    stop(sprintf("data needs to be class 'data.frame, tibble, tbl_df', not %s", class(data)))
  }


  result = switch(
    tableName,
    "JPK_VAT"="JPK_VAT is not supported yet",
    "Faktura"= {

    data %>%
       group_by(P_5B, P_3A) %>%
       select(P_5B, P_3A, P_13_1, P_13_2, P_13_3, P_13_4, P_13_5, P_13_6, P_13_7,
              P_14_1, P_14_2, P_14_3, P_14_4, P_14_5) %>%
       mutate_at(vars(P_13_1:P_14_5), as.numeric) %>%
       mutate(LiczbaFaktur = 1) %>%
       summarise_all(sum, na.rm = T) %>%
       mutate(WartoscFaktur = P_13_1 + P_13_2 + P_13_3 + P_13_4 + P_13_5 + P_13_6 + P_13_7 +
                P_14_1 + P_14_2 + P_14_3 + P_14_4 + P_14_5) %>%
       mutate_if(is.numeric, round, 2) %>%
       arrange(desc(WartoscFaktur)) %>%
       ungroup() %>%
       mutate(Udzial_Proc = WartoscFaktur/sum(WartoscFaktur))
    },
    "JPK_WB"="JPK_WB is not supported yet",
    "JPK_MAG"="JPK_MAG is not supported yet"

  )
  ret <- list(
      typeOfExport = "list",
      testName = "test003",
      export = list(result = as.tibble(result))
      )
  return(ret)
}
