
BIG_XML_TO_SQLITE <-
  function(file_xml = "",
           file_SQL = "Plik_JPK.sqlite",
           bufor_size = 1000) {
    ##0.1.0 Inicjacja bazy danych SQLite (myDB)#####
    RSQLite::dbConnect(RSQLite::SQLite(), file_SQL) -> myDB

    ##0.1.1 wczytanie JPK_FA#####
    JPK_UNKNOWN <- read_xml(file_xml, encoding = "UTF-8")
    ##0.2 Sumy kontrolne dla liczby wierszy####
    ##0.2.1 FakturaCrl ####
    JPK_UNKNOWN %>%
      xml_find_first("//d1:FakturaCtrl") %>%
      as_list() %>%
      unlist() %>%
      t() %>%
      as.tibble() %>%
      select(LiczbaFaktur) %>%
      unlist() %>%
      unname() %>%
      as.numeric() -> JPK_FA_LiczbaFaktur
    ##0.2.2 FakuraWieszCtrl####
    JPK_UNKNOWN %>%
      xml_find_first("//d1:FakturaWierszCtrl") %>%
      as_list() %>%
      unlist() %>%
      t() %>%
      as.tibble() %>%
      select(LiczbaWierszyFaktur) %>%
      unlist() %>%
      unname() %>%
      as.numeric() -> JPK_FA_LiczbaWierszyFaktur

    ## 0.3 Wczytanie JPK jako text + Struktyryzacja#####
    ## 0.3.1 Wczytanie JPK ####
    readLines(path) %>%
      paste(collapse = "\n") %>%
      str_replace_all(pattern = "><", replacement = ">\n<") %>%
      str_split(pattern = "\n") %>%
      unlist() -> JPK_UNKNOWN

    ## 0.3.2 Wyciągniecie indexów z wierszami faktur ####
    index_ST <- grep(JPK_UNKNOWN, pattern = "<Faktura typ=\"G\">")
    index_KC <- grep(JPK_UNKNOWN, pattern = "</Faktura>")
    ## 0.3.2 Umieszczenie faktur w liscie####
    ListaFaktur <- vector("list", length(index_ST))
    for (i in 1:length(index_ST)) {
      ListaFaktur[[i]] <-
        paste(BIG_FILE[index_ST[i]:index_KC[i]], collapse = "\n")
    }

    ## 0.4 Export do SQLita ####

    i <- 1
    k <- 1
    file_SQL <- "JPK.sqlite"
    RSQLite::dbConnect(RSQLite::SQLite(), file_SQL) -> myDB
    bufor <- vector("list", bufor_size)
    for (i in 1:length(ListaFaktur)) {
      ###0.4.3.1 Wczytanie pojedyńczego rekordu do ramki danych####
      ListaFaktur[[i]] %>%
        read_xml(encoding = "UTF-8") %>%
        as_list() %>%
        unlist() %>%
        t() %>%
        as.tibble() -> data

      ###0.4.3.2 Dodanie brakujacych kolumn####
      colnames(data) <-
        str_replace(colnames(data),
                    pattern = "^(Faktura\\.)",
                    replacement = "")
      data <-
        AddMissingColsAndFillWith0(data, ALL_COLS = ALL_COLS_Faktura)

      ###0.4.3.2 Wrzucenie pojeńczego rekordu do buforu####
      bufor[[k]] <- data
      k <- k + 1
      ###0.4.3.3 Przygotowanie buforu do wrzutu do bazy danych####
      if ((i %% bufor_size = 0) | i == length(ListaFaktur)) {
        Data <- bind_rows(bufor)
        data <- convertCharColsToNum(data, guess = T)
        dbWriteTable(myDB, "Faktury", Data, append = T)
        bufor <- vector("list", bufor_size)
        print(i)
        k <- 1
      }

    }

  }
