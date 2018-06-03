# Hello, world!
#
# This is an example function named 'hello'
# which prints 'Hello, world!'.
#
# You can learn more about package authoring with RStudio at:
#
#   http://r-pkgs.had.co.nz/
#
# Some useful keyboard shortcuts for package authoring:
#
#   Build and Reload Package:  'Ctrl + Shift + B'
#   Check Package:             'Ctrl + Shift + E'
#   Test Package:              'Ctrl + Shift + T'

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
  "K_38"
)

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


AddMissingColsAndFillWith0 <- function(df, ALL_COLS) {

  missing_cols <- setdiff(ALL_COLS, colnames(df))
  missing_cols_filled_with_0 <- setNames(data.frame(matrix(ncol = length(missing_cols), nrow = nrow(df))),
                                         missing_cols)
  missing_cols_filled_with_0[is.na(missing_cols_filled_with_0)] <- 0

  df2 <- bind_cols(df, missing_cols_filled_with_0)
  df2 <- df2[,ALL_COLS]
  return(df2)
}
