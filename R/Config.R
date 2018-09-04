#' @export
#'
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
                    FakturaWiersz = ALL_COLS_FakturaWiersz,
                    FakturaCtrl = c("LiczbaFaktur", "WartoscFaktur"),
                    FakturaWierszCtrl = c("LiczbaWierszyFaktur", "WartoscWierszyFaktur"),
                    Naglowek = c("KodFormularza",
                                  "WariantFormularza",
                                  "CelZlozenia",
                                  "DataWytworzeniaJPK",
                                  "DataOd",
                                  "DataDo",
                                  "DomyslnyKodWaluty",
                                  "KodUrzedu"
                    )),
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
                     SprzedazWiersz = ALL_COLS_SprzedazWiersz,
                     ZakupWiersz = ALL_COLS_ZakupyWiersz,
                     SprzedazCtrl = c("LiczbaWierszySprzedazy", "PodatekNalezny"),
                     ZakupCtrl = c("LiczbaWierszyZakupow", "PodatekNaliczony"),
                     Naglowek = c("KodFormularza",
                                  "WariantFormularza",
                                  "CelZlozenia",
                                  "DataWytworzeniaJPK",
                                  "DataOd",
                                  "DataDo",
                                  "DomyslnyKodWaluty",
                                  "KodUrzedu"
                                  )
                   )),
  JPK_MAG = list(Ctrl = list(),
                 Tables = list(),
                 Colnames = list(Naglowek = c("KodFormularza",
                                              "WariantFormularza",
                                              "CelZlozenia",
                                              "DataWytworzeniaJPK",
                                              "DataOd",
                                              "DataDo",
                                              "DomyslnyKodWaluty",
                                              "KodUrzedu"
                                              ),
                                 PZWartosc = c("NumerPZ",
                                               "DataPZ",
                                               "WartoscPZ",
                                               "DataOtrzymaniaPZ",
                                               "Dostawca",
                                               "NumerFaPZ",
                                               "DataFaPZ"
                                 ),
                                 WZWartosc = c("NumerWZ",
                                               "DataWZ",
                                               "WartoscWZ",
                                               "DataWydaniaWZ",
                                               "OdbiorcaWZ",
                                               "NumerFaWZ",
                                               "DataFaWZ"
                                 ),
                                 RWWiersz = c("Numer2RW",
                                               "KodTowaruRW",
                                               "NazwaTowaruRW",
                                               "IloscWydanaRW",
                                               "JednostkaMiaryRW",
                                               "CenaJednRW",
                                               "WartoscPozycjiRW"),
                                 MMWiersz = c("Numer2MM",
                                               "KodTowaruMM",
                                               "NazwaTowaruMM",
                                               "IloscWydanaMM",
                                               "JednostkaMiaryMM",
                                               "CenaJednMM",
                                               "WartoscPozycjiMM"),
                                 PZWiersz = c("Numer2PZ",
                                              "KodTowaruPZ",
                                              "NazwaTowaruPZ",
                                              "IloscPrzyjetaPZ",
                                              "JednostkaMiaryPZ",
                                              "CenaJednPZ",
                                              "WartoscPozycjiPZ"
                                 ),
                                 WZWiersz = c("Numer2WZ",
                                              "KodTowaruWZ",
                                              "NazwaTowaruWZ",
                                              "IloscWydanaWZ",
                                              "JednostkaMiaryWZ",
                                              "CenaJednWZ",
                                              "WartoscPozycjiWZ"
                                 ),
                                 RWWartosc = c("NumerRW",
                                              "DataRW",
                                              "WartoscRW",
                                              "DataWydaniaRW",
                                              "SkadRW",
                                              "DokadRW"
                                 ),
                                 MMWartosc = c("NumerMM",
                                              "DataMM",
                                              "WartoscMM",
                                              "DataWydaniaMM",
                                              "SkadMM",
                                              "DokadMM"),
                                 PZCtrl = c("LiczbaPZ", "SumaPZ"),
                                 WZCtrl = c("LiczbaWZ", "SumaWZ"),
                                 RWCtrl = c("LiczbaRW", "SumaRW"),
                                 MMCtrl = c("LiczbaMM", "SumaMM")
                 )),
  JPK_KR = list(Ctrl = list(),
                 Tables = list(),
                 Colnames = list()),
  JPK_WB = list(Ctrl = list(),
                 Tables = list(),
                Colnames = list(
                  Naglowek = c(
                    "KodFormularza",
                    "WariantFormularza",
                    "CelZlozenia",
                    "DataWytworzeniaJPK",
                    "DataOd",
                    "DataDo",
                    "DomyslnyKodWaluty",
                    "KodUrzedu"
                  ),
                  WyciagWiersz = c(
                    "NumerWiersza",
                    "DataOperacji",
                    "NazwaPodmiotu",
                    "OpisOperacji",
                    "KwotaOperacji",
                    "SaldoOperacji"
                  ),
                  NumerRachunku = "NumerRachunku",
                  Salda = c("SaldoPoczatkowe", "SaldoKoncowe"),
                  WyciagCtrl = c("LiczbaWierszy", "SumaObciazen", "SumaUznan")
                 )),
  JPK_PKPIR = list(Ctrl = list(),
                 Tables = list(),
                 Colnames = list()),
  JPK_EWP = list(Ctrl = list(),
                 Tables = list(),
                 Colnames = list()),
  InvoicePatterns = c("^([A-Z_]+)[/-]([0-9]{2,4})[/-]([0-9]+)[/-]([0-9A-Z]+)$",
                      "^([A-Z_]+)[/-]([0-9]+)[/-]([0-9]{2,4})[/-]([0-9A-Z]+)$",
                      "^([A-Z_]+)[/-]([0-9]{2,4})[/-]([0-9]+)$",
                      "^[0-9]+$",
                      "^([A-Z_]+)[/-]([0-9]+)[/-]([0-9]{2})[/-]([0-9]{2})[/-]([0-9]+)$")
  )


