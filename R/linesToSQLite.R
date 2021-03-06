#' linesToSQLite
#'
#' @param file_xml path to JPK xml file
#' @param bufor_size size of bufor
#' @param SQLiteConnection sqlite connection
#' @param table_name name of table to export data
#' @param record_start record start
#' @param record_end record end
#' @param removeStringfromColnames record end
#' @param colnamesList record end
#'
#' @return SQLite file
#' @export
#'
#'
linesToSQLite <- function(linesOfJPK = JPK_UNKNOWN_text,
                          bufor_size = 10000,
                          SQLiteConnection,
                          table_name,
                          record_start,
                          record_end,
                          removeStringfromColnames = "^(Faktura\\.)",
                          colnamesList) {


  print(record_start)
  print(record_end)
  ## 0.3.2 Wyciągniecie indexów z wierszami faktur ####
  index_ST <- grep(linesOfJPK, pattern = record_start)
  index_KC <- grep(linesOfJPK, pattern = record_end)
  LiczbaDokumentow <- length(index_ST)
  print("Wyciągnieto indexy")
  #print(index_ST[1:5])
  #print(index_KC[1:5])

  ## 0.3.2 Umieszczenie faktur w liscie####
  Record_List <- vector("list", length(index_ST))
  for (rec in 1:length(index_ST)) {
    Record_List[[rec]] <-
      paste(linesOfJPK[index_ST[rec]:index_KC[rec]], collapse = "\n")
  }
  print("Stworzono recordlist")
  ## 0.4 Export do SQLita ####
  ## Jeśli chodzi o sumy kontrolne może tutaj iść pętla po liście do której wrzuce każda z sum kontrolnych

  i <- 1
  k <- 1
  #print(paste0("Nowe i", i))
  #print(paste0("Nowe k", k))
  CzasDoOdliczania <- Sys.time()
  bufor <- vector("list", bufor_size)
  for (i in 1:length(Record_List)) {
      ###0.4.3.1 Wczytanie pojedyńczego rekordu do ramki danych####
    Record_List[[i]] %>%
      read_xml(encoding = "UTF-8") %>%
      as_list() %>%
      unlist() %>%
      t() %>%
      as.tibble() -> data
    ####. Tutaj trzeba zaradzić. (Dopasowane tylko do JPK_FA)
    ###0.4.3.2 Dodanie brakujacych kolumn####
    colnames(data) <-
      str_replace(colnames(data),
                  pattern = removeStringfromColnames,
                  replacement = "")
    data <-
      AddMissingColsAndFillWith0(data, ALL_COLS = colnamesList)

    ###0.4.3.2 Wrzucenie pojeńczego rekordu do buforu####
    bufor[[k]] <- data
    k <- k + 1
    ###0.4.3.3 Przygotowanie buforu do wrzutu do bazy danych####
    if ((i %% bufor_size == 0) | (i == length(Record_List))) {
      data_from_bufor <- bind_rows(bufor)
      data_from_bufor <- convertCharColsToNum(data_from_bufor, guess = T)
      dbWriteTable(SQLiteConnection, table_name, data_from_bufor, append = T)
      bufor <- vector("list", bufor_size)
      print(endTimePrediction(start = as.numeric(CzasDoOdliczania), index = i, lastIndex = length(Record_List), TimeFromStart = T))
      print(endTimePrediction(start = as.numeric(CzasDoOdliczania), index = i, lastIndex = length(Record_List)))
      k <- 1
    }

  }
  #Przeniesione po za pętle
  #dbDisconnect(SQLiteConnection)
}
