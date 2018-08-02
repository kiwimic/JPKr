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
                    FakturaWiersz = ALL_COLS_FakturaWiersz),
    Col_numer_dokumentu = "P_2A"
  ),
  JPK_VAT = list(Ctrl = list(
    SprzedazCtrl = c("SprzedazCtrl", "/tns:JPK/tns:SprzedazCtrl"),
    ZakupCtrl = c("ZakupCtrl", "/tns:JPK/tns:ZakupCtrl")
  ),
                   Tables = list(
                     SprzedazWiersz = c("SprzedazWiersz", "<SprzedazWiersz typ=\"G\">", "</SprzedazWiersz>", "^(SprzedazWiersz\\.)"),
                     ZakupyWiersz = c("ZakupWiesz", "ZakupWiersz typ=\"G\">", "</ZakupWiersz>", "^(ZakupWiersz\\.)")
                   ),
                   Colnames = list(
                     Sprzedaz = ALL_COLS_SprzedazWiersz,
                     Zakup = ALL_COLS_ZakupyWiersz
                   )),
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
                 Colnames = list()),
  InvoicePatterns = c("([A-Z_]+)[/-]([0-9]{2,4})[/-]([0-9]+)[/-]([0-9A-Z]+)",
                      "([A-Z_]+)[/-]([0-9]+)[/-]([0-9]{2,4})[/-]([0-9A-Z]+)",
                      "([A-Z_]+)[/-]([0-9]{2,4})[/-]([0-9]+)")

  )

