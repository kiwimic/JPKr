
#' test004
#' Sluzy do podsumowania kontrahentow w podziale na polski i zagraniczny NIP
#' T/F czy polski nip, NIP kontrahenta, nazwa kontrahenta, wartosc dokumentow, liczba dokumentow
#'
#' @param data must be converted to numeric data.frame with JPK FA, or JPK_VAT
#'
#' @return return tibble with summarise of values, counts, max, min, of documents for one NIP
#'
#'
#' @export
#'
#' @examples
test004 <- function(data = NA, tableName = NA) {
  if (is.na(tableName)) {
    stop(sprintf("please pass tableName argument in test04 function"))
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
       mutate(Udzial_Proc = WartoscFaktur/sum(WartoscFaktur)) %>%
       mutate(CzyPolskiNIP = isPolishNIP(P_5B)) %>%
       select(CzyPolskiNIP, P_5B, P_3A, WartoscFaktur, Udzial_Proc, LiczbaFaktur)
    },
    "SprzedazWiersz"= {

      data %>%
        group_by(NrKontrahenta, NazwaKontrahenta) %>%
        select(NrKontrahenta, NazwaKontrahenta, K_10:K_39) %>%
        mutate_at(vars(K_10:K_39), as.numeric) %>%
        mutate(LiczbaDokumentow = 1) %>%
        summarise_all(sum, na.rm = T) %>%
        mutate(
          WartoscDokumentow = K_10 + K_11 + K_12 + K_13 + K_14 + K_15 + K_17 + K_19 + K_21
          + K_22 + K_23 + K_25 + K_27 + K_29 + K_31 + K_32 + K_34
        ) %>%
        mutate_if(is.numeric, round, 2) %>%
        arrange(desc(WartoscDokumentow)) %>%
        ungroup() %>%
        mutate(Udzial_Proc = WartoscDokumentow / sum(WartoscDokumentow)) %>%
        mutate(CzyPolskiNIP = isPolishNIP(NrKontrahenta)) %>%
        select(CzyPolskiNIP, NrKontrahenta, NazwaKontrahenta, WartoscDokumentow, Udzial_Proc, LiczbaDokumentow)
    },
    "ZakupWiersz"= {

      data %>%
        group_by(NrDostawcy, NazwaDostawcy) %>%
        select(NrDostawcy, NazwaDostawcy, K_43:K_45) %>%
        mutate_at(vars(K_43, K_45), as.numeric) %>%
        mutate(LiczbaDokumentow = 1) %>%
        summarise_all(sum, na.rm = T) %>%
        mutate(
          WartoscDokumentow = K_43 + K_45
        ) %>%
        mutate_if(is.numeric, round, 2) %>%
        arrange(desc(WartoscDokumentow)) %>%
        ungroup() %>%
        mutate(Udzial_Proc = WartoscDokumentow / sum(WartoscDokumentow)) %>%
        mutate(CzyPolskiNIP = isPolishNIP(NrDostawcy)) %>%
        select(CzyPolskiNIP, NrDostawcy, NazwaDostawcy, WartoscDokumentow, Udzial_Proc, LiczbaDokumentow)
    }


  )
  ret <- list(
      typeOfExport = "list",
      testName = "test004",
      export = list(result = as.tibble(result))
      )
  return(ret)
}
