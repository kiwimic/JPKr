


#' Title
#'
#' @param file_xml
#' @param file_SQL
#' @param export_dir
#' @param bufor_size
#' @param jpk_type
#'
#' @return
#' @export
#'
#' @examples
GO_xmlToSQLite <- function(file_xml = "",
                           SQLiteConnection = myDB,
                           export_dir = "",
                           bufor_size = 10000,
                           jpk_type = JPK_TYPE) {

  #### Przygotowanie ścieżek pod GO ####
  file_xml <- shQuote(paste0(getwd(),"/", file_xml))
  CSV_dir <- paste0(getwd(),"/", export_dir, "/", "CSV")
  if (!dir.exists(CSV_dir)) {
    dir.create(path = CSV_dir)
  }
  CSV_dir_Q <- shQuote(CSV_dir)
  export_dir <- paste0(getwd(),"/", export_dir)
  if (!dir.exists(export_dir)) {
    dir.create(path = export_dir)
  }
  export_dir <- shQuote(paste0(getwd(),"/", export_dir))


  #### Skrocenie typu JPK
  jpk_type_GO <- jpk_type %>%
    tolower() %>%
    str_remove(pattern = "jpk_")

  #### Komenda golang #####
  command <- paste0('jpk ', jpk_type_GO, ' --file ', file_xml,' --dir ',CSV_dir_Q)

  system(
    command
  )


  #################
  NazwyPlikow       <- list.files(path = CSV_dir, pattern = "(.txt)$")
  LokalizacjePlikow <- list.files(path = CSV_dir, pattern = "(.txt)$", full.names = T)
  NazwyPlikow <- str_remove(NazwyPlikow, pattern = "(.txt)$")

  print("Lokalizacaje plików to: ")
  print(LokalizacjePlikow)
  dbWriteTable(SQLiteConnection,
               name = "TYP",
               value = tibble(TYP = jpk_type),
               append = F,
               overwrite = T)

  for (i in 1:length(LokalizacjePlikow)) {
    Nazwa <- NazwyPlikow[i]
    Lokalizacja <- LokalizacjePlikow[i]
    col_names <- JPK_CONFIG[[jpk_type]]$Colnames[[Nazwa]]
    temp_read <- read_csv2(file = Lokalizacja,
                           col_names = F)

    colnames(temp_read) <- col_names
    temp_read <- AddMissingColsAndFillWith0(df = temp_read, ALL_COLS = col_names)
    temp_read <- convertCharColsToNum(df = temp_read, guess = T)
    dbWriteTable(SQLiteConnection, Nazwa, temp_read, append = T)
    print(paste0("Zapisano: ", Nazwa))
  }
}
