JPK_CONFIG <-
  list(JPK_FA = list(
    Ctrl = list(
      FakturaCtrl = c("FakturaCtrl", "//d1:FakturaCtrl"),
      FakturaWierszCtrl = c("FakturaWierszCtrl", "//d1:FakturaWierszCtrl")
    ),
    Tables = list(
      Faktura = c(
        "Faktura",
        "<Faktura typ=\"G\">",
        "</Faktura>",
        "^(Faktura\\.)"
      ),
      FakturaWiersz = c(
        "FakturaWiersz",
        "<FakturaWiersz typ=\"G\">",
        "</FakturaWiersz>",
        "^(FakturaWiersz\\.)"
      )
    ),
    Colnames = list(Faktura = ALL_COLS_Faktura,
                    FakturaWiersz = ALL_COLS_FakturaWiersz)
  ),
  JPK_VAT_2 = list(Ctrl = list(),
                   Tables = list(),
                   Colnames = list()),
  JPK_VAT_3 = list(Ctrl = list(),
                   Tables = list(),
                   Colnames = list()),
  JPK_MAG = list(Ctrl = list(),
                 Tables = list(),
                 Colnames = list()),
  JPK_KR = list(Ctrl = list(),
                 Tables = list(),
                 Colnames = list()),
  JPK_WB = list(Ctrl = list(),
                 Tables = list(),
                 Colnames = list()),
  JPK_PKPIR = list(Ctrl = list(),
                 Tables = list(),
                 Colnames = list()),
  JPK_EWP = list(Ctrl = list(),
                 Tables = list(),
                 Colnames = list())

  )


