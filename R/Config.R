JPK_CONFIG <-
  list(JPK_FA = list(
    Ctrl = list(
      FakturaCtrl = c("JPK_FA_FakturaCtrl", "//d1:FakturaCtrl"),
      FakturaWierszCtrl = c("JPK_FA_FakturaWierszCtrl", "//d1:FakturaWierszCtrl")
    ),
    Tables = list(Faktura = c("Faktura", "<Faktura typ=\"G\">", "</Faktura>"),
                  FakturaWiersz = "FakturaWiersz")
  ))
