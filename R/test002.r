
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
#'
test002 <- function(data = NA, controlSumsFromFile = NA, tableName = NA) {
  if (is.na(tableName)) {
    stop(sprintf("please pass tableName argument in test002 function"))
  }
  if ((sum(class(data) %in% c("data.frame", "tibble", "tbl_df"))==0)) {
    stop(sprintf("data needs to be class 'data.frame, tibble, tbl_df', not %s", class(data)))
  }
  if ((sum(class(controlSumsFromFile) %in% c("data.frame", "tibble", "tbl_df"))==0)) {
    stop(sprintf("controlSumsFromFile needs to be class 'data.frame, tibble, tbl_df', not %s", class(controlSumsFromFile)))
  }

  result_test <- F

  computedControlSums = switch(
    tableName,
    "FakturaWiersz"= {
      data %>%
        select(P_11, P_11A) %>%
        mutate_all(as.numeric) %>%
        mutate(LiczbaWierszyFaktur = 1) %>%
        summarise_all(sum, na.rm = T) %>%
        mutate(WartoscWierszyFaktur = P_11 + P_11A) %>%
        mutate_all(round, 2) %>%
        select(LiczbaWierszyFaktur, WartoscWierszyFaktur)
    },
    "SprzedazWiersz"= {
      data %>%
        mutate(LiczbaWierszy = 1) %>%
        summarise_if(is.numeric, sum, na.rm = T) %>%
        summarise(
          LiczbaWierszySprzedazy = sum(LiczbaWierszy),
          PodatekNalezny = K_16+K_18+K_20+K_24+K_26+K_28+K_30+K_33+K_35+K_36+K_38+K_39
          ) %>%
        mutate_all(round, 2) %>%
        select(LiczbaWierszySprzedazy, PodatekNalezny)
    },
    "ZakupWiersz"= {
      data %>%
      mutate(LiczbaWierszy = 1) %>%
        summarise_if(is.numeric, sum, na.rm = T) %>%
        summarise(
          LiczbaWierszyZakupow = sum(LiczbaWierszy),
          PodatekNaliczony =K_44+ K_46+K_47+K_48+K_49+K_50
        )
    },
    "Faktura"= {

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
    "PZWartosc"= {

      data %>%
        mutate(LiczbaPZ = 1) %>%
        summarise(SumaPZ = sum(WartoscPZ, na.rm = T),
                  LiczbaPZ = sum(LiczbaPZ, na.rm = T)) %>%
        mutate(SumaPZ = round(SumaPZ, 2)) %>%
        select(LiczbaPZ, SumaPZ)

    },
    "PZWiersz"="PZWiersz is not supported yet",
    "WZWartosc"= {
      data %>%
        mutate(LiczbaWZ = 1) %>%
        summarise(SumaWZ = sum(WartoscWZ, na.rm = T),
                  LiczbaWZ = sum(LiczbaWZ, na.rm = T)) %>%
        mutate(SumaWZ = round(SumaWZ, 2)) %>%
        select(LiczbaWZ, SumaWZ)
    },
    "RWWartosc"= {

      data %>%
        mutate(LiczbaRW = 1) %>%
        summarise(SumaRW = sum(WartoscRW, na.rm = T),
                  LiczbaRW = sum(LiczbaRW, na.rm = T)) %>%
        mutate(SumaRW = round(SumaRW, 2)) %>%
        select(LiczbaRW, SumaRW)
    },
    "MMWartosc"= {

      data %>%
        mutate(LiczbaMM = 1) %>%
        summarise(SumaMM = sum(WartoscMM, na.rm = T),
                  LiczbaMM = sum(LiczbaMM, na.rm = T)) %>%
        mutate(SumaMM = round(SumaMM, 2)) %>%
        select(LiczbaMM, SumaMM)

    },
    "WZWiersz"="WZWiersz is not supported yet",
    "JPK_MAG"="JPK_MAG is not supported yet",
    "WyciagWiersz" = {

      data %>%
        select(KwotaOperacji) %>%
        mutate(Znak = if_else(KwotaOperacji>0, "Plus", "Minus")) %>%
        mutate(LiczbaWierszy = 1) %>%
        group_by(Znak) %>%
        summarise(KwotaOperacji = sum(KwotaOperacji, na.rm = T),
                  LiczbaWierszy = sum(LiczbaWierszy)) %>%
        spread(Znak, KwotaOperacji) %>%
        summarise(LiczbaWierszy = sum(LiczbaWierszy),
                  Minus = sum(Minus, na.rm = T),
                  Plus = sum(Plus, na.rm = T)) %>%
        mutate(Minus = round(Minus, 2),
               Plus = round(Plus, 2)) %>%
        select(LiczbaWierszy, SumaObciazen = Minus, SumaUznan = Plus)

    }

  )
  ### Zabezpieczenie na puste sumy kontrolne ####
  controlSumsFromFile[is.na(controlSumsFromFile)] <- 0

  if (identical(computedControlSums, controlSumsFromFile)) {
    result_test <- TRUE
  }
  result <- list(
    typeOfExport = "list",
    testName = "test002",
    export = list(
    result = tibble(result_test),
    controlSumsFromFile = controlSumsFromFile,
    computedControlSums = computedControlSums
    )
  )
  return(result)
}



