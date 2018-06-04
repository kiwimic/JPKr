#' AddMissingColsAndFillWith0
#'
#' @param df dataframe from JPK file, for now is: SprzedazWiersz, ZakupyWiersz, FakturaWiersz, Faktura
#' @param ALL_COLS character vector with list of all cols of full JPK inside table, for now is: SprzedazWiersz, ZakupyWiersz, FakturaWiersz, Faktura
#'
#' @return df filled with all missing columns.
#'
#'
#'
#'
AddMissingColsAndFillWith0 <- function(df, ALL_COLS) {
if (sum(colnames(df) %in% ALL_COLS) == length(ALL_COLS)) {
  ret <- df[,ALL_COLS]
} else {
  missing_cols <- setdiff(ALL_COLS, colnames(df))
  missing_cols_filled_with_0 <- setNames(data.frame(matrix(ncol = length(missing_cols), nrow = nrow(df))),
                                         missing_cols)
  missing_cols_filled_with_0[is.na(missing_cols_filled_with_0)] <- 0

  df2 <- bind_cols(df, missing_cols_filled_with_0)
  df2 <- df2[,ALL_COLS]
  ret <- df2
}
return(ret)

}


ALL_COLS_SprzedazWiersz <- c(
  "LpSprzedazy",
  "NrKontrahenta",
  "NazwaKontrahenta",
  "AdresKontrahenta",
  "DowodSprzedazy",
  "DataWystawienia",
  "DataSprzedazy",
  "K_10",
  "K_11",
  "K_12",
  "K_13",
  "K_14",
  "K_15",
  "K_16",
  "K_17",
  "K_18",
  "K_19",
  "K_20",
  "K_21",
  "K_22",
  "K_23",
  "K_24",
  "K_25",
  "K_26",
  "K_27",
  "K_28",
  "K_29",
  "K_30",
  "K_31",
  "K_32",
  "K_33",
  "K_34",
  "K_35",
  "K_36",
  "K_37",
  "K_38",
  "K_39"
)

###JPK_VAT_2###
ALL_COLS_ZakupyWiersz <- c(
  "LpZakupu",
  "NrDostawcy",
  "NazwaDostawcy",
  "AdresDostawcy",
  "DowodZakupu",
  "DataZakupu",
  "DataWplywu",
  "K_43",
  "K_44",
  "K_45",
  "K_46",
  "K_47",
  "K_48",
  "K_49",
  "K_50"
)

###JPK_FA#####
ALL_COLS_Faktura <- c("P_1",
                      "P_2A",
                      "P_3A",
                      "P_3B",
                      "P_3C",
                      "P_3D",
                      "P_4A",
                      "P_4B",
                      "P_5A",
                      "P_5B",
                      "P_6",
                      "P_13_1",
                      "P_14_1",
                      "P_13_2",
                      "P_14_2",
                      "P_13_3",
                      "P_14_3",
                      "P_13_4",
                      "P_14_4",
                      "P_13_5",
                      "P_14_5",
                      "P_13_6",
                      "P_13_7",
                      "P_15",
                      "P_16",
                      "P_17",
                      "P_18",
                      "P_19",
                      "P_19A",
                      "P_19B",
                      "P_19C",
                      "P_20",
                      "P_20A",
                      "P_20B",
                      "P_21",
                      "P_21A",
                      "P_21B",
                      "P_21C",
                      "P_22A",
                      "P_22B",
                      "P_22C",
                      "P_23",
                      "P_106E_2",
                      "P_106E_3",
                      "P_106E_3A",
                      "RodzajFaktury",
                      "PrzyczynaKorekty",
                      "NrFaKorygowanej",
                      "OkresFaKorygowanej",
                      "ZALZaplata",
                      "ZALPodatek"
                      )

###JPK_FA#####
ALL_COLS_FakturaWiersz <- c("P_2B",
                            "P_7",
                            "P_8A",
                            "P_8B",
                            "P_9A",
                            "P_9B",
                            "P_10",
                            "P_11",
                            "P_11A",
                            "P_12"
                            )





