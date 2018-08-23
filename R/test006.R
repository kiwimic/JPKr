
#' test005
#' Służy do zweryfikowania czy podatki zostały właściwie obliczone
#'
#'
#' @param data must be converted to numeric data.frame with JPK FA, or JPK_VAT
#'
#' @return return tibble with summarise of values, counts, max, min, of documents for one NIP
#'
#'@export
#'
test006 <- function(data = NA, tableName = NA) {
  if (is.na(tableName)) {
    stop(sprintf("please pass tableName argument in test06 function"))
  }
  if ((sum(class(data) %in% c("data.frame", "tibble", "tbl_df"))==0)) {
    stop(sprintf("data needs to be class 'data.frame, tibble, tbl_df', not %s", class(data)))
  }


  result = switch(
    tableName,
    "FakturaWiersz"= {
      tibble(Opis = "Brak podatkow")
    },
    "Faktura"= {

    data %>%
        select(P_2A, P_13_1, P_13_2, P_13_3, P_13_4, P_13_5, P_13_6, P_13_7,
               P_14_1, P_14_2, P_14_3, P_14_4, P_14_5) %>%
        mutate_at(vars(P_13_1:P_14_5), as.numeric) %>%
        mutate(Podatek_22_23 = round(P_14_1/P_13_1,2),
               Podatek_07_08 = round(P_14_2/P_13_2,2),
               Podatek_05 = round(P_14_3/P_13_3,2),
               Podatek_stawka_3_OB = round(P_14_4/P_13_4,2),
               Podatek_stawka_4_OB = round(P_14_5/P_13_5,2)) %>%
        select(P_2A, starts_with("Podatek")) -> ObliczonePodatki

      ObliczonePodatki %>%
        filter(!is.na(Podatek_22_23)) %>%
        filter(!Podatek_22_23 %in% c(0.23, 0.22)) %>%
        mutate(Opis = "Zle obliczony podatek 22_23")-> P1

      ObliczonePodatki %>%
        filter(!is.na(Podatek_07_08)) %>%
        filter(!Podatek_07_08 %in% c(0.08, 0.07)) %>%
        mutate(Opis = "Zle obliczony podatek 07_08")-> P2

      ObliczonePodatki %>%
        filter(!is.na(Podatek_05)) %>%
        filter(!Podatek_05 %in% c(0.05)) %>%
        mutate(Opis = "Zle obliczony podatek 05")-> P3

      ZlePodatki <- bind_rows(P1, P2, P3)


      return(list(ObliczonePodatki = ObliczonePodatki,
                  ZleObliczonePodatki = ZlePodatki))
    },
    "SprzedazWiersz"= {

      data %>%
        mutate(Podatek_22_23 = round(K_20/K_19,2),
               Podatek_07_08 = round(K_18/K_17,2),
               Podatek_05 = round(K_16/K_15,2),
               Podatek_wew_nab_tow = round(K_24/K_23,2),
               Podatek_imp_tow = round(K_26/K_25,2),
               Podatek_imp_tow2 = round(K_28/K_27,2),
               Podatek_imp_tow3 = round(K_30/K_29,2)) %>%
        select(DowodSprzedazy, starts_with("Podatek")) -> ObliczonePodatki


      ObliczonePodatki %>%
        filter(!is.na(Podatek_22_23)) %>%
        filter(!Podatek_22_23 %in% c(0.23, 0.22)) %>%
        mutate(Opis = "Zle obliczony podatek 22_23")-> P1

      ObliczonePodatki %>%
        filter(!is.na(Podatek_07_08)) %>%
        filter(!Podatek_07_08 %in% c(0.08, 0.07)) %>%
        mutate(Opis = "Zle obliczony podatek 07_08")-> P2

      ObliczonePodatki %>%
        filter(!is.na(Podatek_05)) %>%
        filter(!Podatek_05 %in% c(0.05)) %>%
        mutate(Opis = "Zle obliczony podatek 05")-> P3

      ZlePodatki <- bind_rows(P1, P2, P3)


      return(list(ObliczonePodatki = ObliczonePodatki,
                  ZleObliczonePodatki = ZlePodatki))
    },
    "ZakupWiersz"= {

     tibble(Opis = "Brak podatkow")
    }


  )
  ret <- list(
      typeOfExport = "list",
      testName = "test006",
      export = result
      )
  return(ret)
}
