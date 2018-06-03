
library(xml2)
library(dplyr)
library(tibble)
library(stringr)
library(writexl)


JPK_FA_XML_TO_LIST <- function(file_xml = "", file_xlsx = "") {
  start <- Sys.time()

  if (length(grep(file_xlsx, pattern = "(\\.xlsx)$")) == 0) {
    file_xlsx <- paste0(file_xlsx, ".xlsx")
  }

  JPK_FA <- xml2::read_xml(x = file_xml) %>%
    as_list()

  ##1. Nagłowek###########
  Naglowek <- JPK_FA["Naglowek"]
  Naglowek_DF <- as.data.frame(Naglowek)

  ##2. Podmiot1###############
  Podmiot1a <- JPK_FA["Podmiot1"][["Podmiot1"]][["IdentyfikatorPodmiotu"]]
  Podmiot1b <- JPK_FA["Podmiot1"][["Podmiot1"]][["AdresPodmiotu"]]
  Podmiot1_DF <- bind_cols(
    bind_rows(unlist(Podmiot1a)),
    bind_rows(unlist(Podmiot1b))
  )

  ##3. Faktura####################################

  Faktura <- JPK_FA[grep(names(JPK_FA), pattern = "^Faktura$")]
  Faktura <- bind_rows(Faktura)

  Faktura <- rmCharNULLfromDF(Faktura)
  Faktura <- convertCharColsToNum(Faktura, colsToConv = c("P_13_1",
                                                              "P_13_2",
                                                              "P_13_4",
                                                              "P_13_7",
                                                              "P_14_1",
                                                              "P_14_2",
                                                              "P_14_4",
                                                              "P_15"
  ))
  Faktura <- AddMissingColsAndFillWith0(Faktura, ALL_COLS_Faktura)


  ##4. FakturaCtrl##
  FakturaCtrl <- JPK_FA["FakturaCtrl"] %>%
    unname() %>%
    unlist() %>%
    t() %>%
    as.data.frame(stringsAsFactors = F)


  ##5. StawkiPodatku#############

  StawkiPodatku <- JPK_FA["StawkiPodatku"] %>%
    unname() %>%
    unlist() %>%
    t() %>%
    as.data.frame()

  ##6. FakturaWiersz #######
  FakturaWiersz <- JPK_FA[grep(names(JPK_FA), pattern = "^FakturaWiersz$")]
  FakturaWiersz <- bind_rows(FakturaWiersz)

  FakturaWiersz <- rmCharNULLfromDF(FakturaWiersz)
  FakturaWiersz <- convertCharColsToNum(FakturaWiersz, colsToConv = c("P_8B",
                                                                          "P_9A",
                                                                          "P_11",
                                                                          "P_11A"
  ))

  FakturaWiersz <- AddMissingColsAndFillWith0(FakturaWiersz, ALL_COLS_FakturaWiersz)

  ##7. FakturaWierszCtrl##
  FakturaWierszCtrl <- JPK_FA["FakturaWierszCtrl"] %>%
    unname() %>%
    unlist() %>%
    t() %>%
    as.data.frame(stringsAsFactors = F)



  #8. Testy########
  #8.1 Faktura###############
  #8.1.1 Liczba wierszy#######
  if (as.numeric(FakturaCtrl$LiczbaFaktur[1]) != nrow(Faktura)) {
    stop(sprintf("Liczba faktur z 'FakturyCtrl' to %d, natomiast liczba faktur z 'Faktury' to %d ",
                 as.numeric(FakturaCtrl$LiczbaFaktur[1]),
                 nrow(Faktura)))
  }
  ##8.1.2 Podatek należny#######


  ##8.2 Zakup#################
  ##8.2.1 Liczba wierszy#######
  # if (as.numeric(ZakupCtrl$LiczbaWierszyZakupow[1]) != nrow(ZakupWiersz)) {
  #   stop(sprintf("Liczba wierszy z SprzedazCtrl to %d, natomiast liczba wierszy z SprzedazWiersz to %d ",
  #           as.numeric(ZakupCtrl$LiczbaWierszyZakupow[1]),
  #           nrow(ZakupWiersz)))
  # }
  # #8.2.2 Podatek należny#######

  ##9. Zapis do .Rdata##############
  Lista_JPK_FA <- list(
    Naglowek = Naglowek_DF,
    Podmiot1 = Podmiot1_DF,
    Faktura = Faktura,
    FakturaCtrl = FakturaCtrl,
    StawkiPodatku = StawkiPodatku,
    FakturaWiersz = FakturaWiersz,
    FakturaWierszCtrl = FakturaWierszCtrl
  )

  save(Lista_JPK_FA,
       file = paste0(gsub(file_xlsx,
                          pattern = "\\.",
                          replacement = ""),
                     ".Rdata"))
  ##10. Zapis do XLSX ####
  writexl::write_xlsx(x = Lista_JPK_FA, path = file_xlsx)

  # xlsx::write.xlsx(x = Naglowek_DF, file = file_xlsx, sheetName = "Naglowek")
  # xlsx::write.xlsx(x = Podmiot1_DF, file = file_xlsx, sheetName = "Podmiot1", append = T)
  # xlsx::write.xlsx(x = Faktura, file = file_xlsx, sheetName = "Faktura", append = T)
  # xlsx::write.xlsx(x = FakturaCtrl, file = file_xlsx, sheetName = "FakturaCtrl", append = T)
  # xlsx::write.xlsx(x = StawkiPodatku, file = file_xlsx, sheetName = "StawkiPodatku", append = T)
  # xlsx::write.xlsx(x = FakturaWiersz, file = file_xlsx, sheetName = "FakturaWiersz", append = T)
  # xlsx::write.xlsx(x =  FakturaWierszCtrl, file = file_xlsx, sheetName = "FakturaWierszCtrl", append = T)

  ##11. Komunikaty po zakończeniu funkcji ####
  print(paste0("Plik zapisano w lokalizacji: ", paste0(getwd(), "/", file_xlsx)))
  print("Konwersja z pliku xml do xlsx trwała: ")
  print(Sys.time() - start)

 return(Lista_JPK_FA)
}
