#To jest funkcja, która konwertuje plik JPK_VAT_2 z formatu XML to Listy,
#oraz następuje export do pliku excel tego pliku, która zawiera wszystkie
#tabele z pliku JPK tj.:
#Naglowek
#Podmiot1
#SprzedazWiersz
#SprzedazCtrl
#ZakupyWiersz
#ZakupyCtrl
#

library(xml2)
library(dplyr)
library(tibble)
library(stringr)
library(writexl)


JPK_VAT_2_XML_TO_LIST <- function(file_xml = "", file_xlsx = "") {
  start <- Sys.time()

  if (length(grep(file_xlsx, pattern = "(\\.xlsx)$")) == 0) {
    file_xlsx <- paste0(file_xlsx, ".xlsx")
  }

  JPK_VAT2 <- xml2::read_xml(x = file_xml) %>%
    as_list() -> JPK_VAT2

  ##1. Nagłowek###########
  Naglowek <- JPK_VAT2["Naglowek"]
  Naglowek_DF <- as.data.frame(Naglowek)

  ##2. Podmiot1###############
  Podmiot1a <- JPK_VAT2["Podmiot1"][["Podmiot1"]][["IdentyfikatorPodmiotu"]]
  Podmiot1b <- JPK_VAT2["Podmiot1"][["Podmiot1"]][["AdresPodmiotu"]]
  Podmiot1_DF <- bind_cols(
    bind_rows(unlist(Podmiot1a)),
    bind_rows(unlist(Podmiot1b))
  )

  ##3. SprzedazWiersz####################################

  SprzedazWiersz <- JPK_VAT2[grep(names(JPK_VAT2), pattern = "^SprzedazWiersz$")]
  SprzedazWiersz <- bind_rows(SprzedazWiersz)

  SprzedazWiersz <- removeCharNULLfromDF(SprzedazWiersz)
  SprzedazWiersz <- convertCharKcoltoNumeric(SprzedazWiersz)

  SprzedazWiersz <- AddMissingColsAndFillWith0(SprzedazWiersz, ALL_COLS_SprzedazWiersz)

  ##4. SprzedazCtrl####
  SprzedazCtrl <- JPK_VAT2["SprzedazCtrl"] %>%
    unname() %>%
    unlist() %>%
    t() %>%
    as.tibble() %>%
    mutate(LiczbaWierszySprzedazy = as.numeric(LiczbaWierszySprzedazy),
           PodatekNalezny = as.numeric(PodatekNalezny))


  ##5. ZakupyWiersz#############

  ZakupWiersz<- JPK_VAT2[grep(names(JPK_VAT2), pattern = "^ZakupWiersz$")]
  ZakupWiersz <- bind_rows(ZakupWiersz)

  ZakupWiersz <- removeCharNULLfromDF(ZakupWiersz)
  ZakupWiersz <- convertCharKcoltoNumeric(ZakupWiersz)

  ZakupyWiersz <- AddMissingColsAndFillWith0(ZakupyWiersz, ALL_COLS_ZakupyWiersz)

  ##6. ZakupCtrl####
  ZakupCtrl <- JPK_VAT2["ZakupCtrl"] %>%
    unname() %>%
    unlist() %>%
    t() %>%
    as.tibble() %>%
    mutate(LiczbaWierszyZakupow = as.numeric(LiczbaWierszyZakupow),
           PodatekNaliczony = as.numeric(PodatekNaliczony))



  ##7. Testy########
  ##7.1 Sprzedaz###############
  ##7.1.1 Liczba wierszy#######
  if (SprzedazCtrl$LiczbaWierszySprzedazy[1] != nrow(SprzedazWiersz)) {
    stop(sprintf("Liczba wierszy z SprzedazCtrl to %d, natomiast liczba wierszy z SprzedazWiersz to %d ",
                 SprzedazCtrl$LiczbaWierszySprzedazy[1],
                 nrow(SprzedazWiersz)))
  }
      ##7.1.2 Podatek należny#######
  SprzedazWiersz_PodatekNalezny <- SprzedazWiersz %>%
    mutate(Podatek_Nalezny_Razem = K_16+K_18+K_20+K_24+K_26+K_28+K_30+K_33+K_35+K_36+K_38+K_39) %>%
    select(Podatek_Nalezny_Razem) %>%
    summarise(Podatek_Nalezny_Razem = sum(Podatek_Nalezny_Razem, na.rm = T))

  if (SprzedazCtrl$PodatekNalezny[1] != SprzedazWiersz_PodatekNalezny$Podatek_Nalezny_Razem[1]) {
    stop(sprintf("Podatek należny z SprzedazCtrl to %.2f, natomiast podatek należny z SprzedazWiersz to %.2f ",
                 SprzedazCtrl$PodatekNalezny[1],
                 sum(SprzedazWiersz_PodatekNalezny$Podatek_Nalezny_Razem)))
  }

  ##7.2 Zakup#################
  ##7.2.1 Liczba wierszy#######
  if (as.numeric(ZakupCtrl$LiczbaWierszyZakupow[1]) != nrow(ZakupWiersz)) {
    stop(sprintf("Liczba wierszy z SprzedazCtrl to %d, natomiast liczba wierszy z SprzedazWiersz to %d ",
                 as.numeric(ZakupCtrl$LiczbaWierszyZakupow[1]),
                 nrow(ZakupWiersz)))
  }
  ##7.2.2 Podatek naliczony#######
  ZakupyWiersz_PodatekNaliczony <- ZakupyWiersz %>%
    mutate(Podatek_Naliczony_Razem = K_16+K_18+K_20+K_24+K_26+K_28+K_30+K_33+K_35+K_36+K_38+K_39) %>%
    select(Podatek_Naliczony_Razem) %>%
    summarise(Podatek_Naliczony_Razem = sum(Podatek_Naliczony_Razem, na.rm = T))

  if (ZakupyCtrl$PodatekNaliczony[1] != ZakupyWiersz_PodatekNaliczony$Podatek_Naliczony_Razem[1]) {
    stop(sprintf("Podatek naliczony z ZakupyCtrl to %.2f, natomiast podatek naliczony z ZakupyWiersz to %.2f ",
                 ZakupCtrl$PodatekNaliczony[1],
                 sum(ZakupyWiersz_PodatekNaliczony$Podatek_Naliczony_Razem)))
  }

  ##8. Zapis do .Rdata##############
  Lista_JPK_VAT_2 <- list(
    Naglowek = Naglowek_DF,
    Podmiot1 = Podmiot1_DF,
    SprzedazWiersz = SprzedazWiersz,
    SprzedazCtrl = SprzedazCtrl,
    ZakupWiersz = ZakupWiersz,
    ZakupCtrl = ZakupCtrl
  )

  save(Lista_JPK_VAT_2,
       file = paste0(gsub(file_xlsx,
                          pattern = "\\.",
                          replacement = ""),
                     ".Rdata"))
  ##9. Zapis do XLSX ####
  # xlsx::write.xlsx(x = Naglowek_DF, file = file_xlsx, sheetName = "Naglowek")
  # xlsx::write.xlsx(x = Podmiot1_DF, file = file_xlsx, sheetName = "Podmiot1", append = T)
  # xlsx::write.xlsx(x = SprzedazWiersz, file = file_xlsx, sheetName = "SprzedazWiersz", append = T)
  # xlsx::write.xlsx(x = SprzedazCtrl, file = file_xlsx, sheetName = "SprzedazCtrl", append = T)
  # xlsx::write.xlsx(x = ZakupWiersz, file = file_xlsx, sheetName = "ZakupWiersz", append = T)
  # xlsx::write.xlsx(x = ZakupCtrl, file = file_xlsx, sheetName = "ZakupCtrl", append = T)

  ##9.1 #### Wywalenie potrzeby korzystania z javy. (Wersja writexl z githuba)####
  writexl::write_xlsx(x = Lista_JPK_VAT_2, path = file_xlsx)

  ##10. Komunikaty po zakończeniu funkcji ####
  print(paste0("Plik zapisano w lokalizacji: ", paste0(getwd(), "/", file_xlsx)))
  print("Konwersja z pliku xml do xlsx trwała: ")
  print(Sys.time() - start)

  return(Lista_JPK_VAT_2)
}
