


#' Fun which use golang to fast parse xml jpk file and write csv with ";"
#'
#' @param file_xml location of xml file
#' @param SQLiteConnection conn to SQLite file
#' @param export_dir directory where csv files will be written
#' @param bufor_size size of one time write to connection
#' @param jpk_type type of jpk for example "JPK_VAT", "JPK_FA"
#'
#' @return csv files of with lines of jpk tables and sqlconnection filled with this files
#' @export
#'
 GO_xmlToSQLite <- function(file_xml = "",
                           SQLiteConnection = myDB,
                           export_dir = "",
                           bufor_size = 10000,
                           jpk_type = JPK_TYPE,
                           argParse = NA,
                           NazwyPlikow_TIME = NA,
                           useGObinary = useGObinary,
                           binary_dir = NA) {

  #### Przygotowanie ścieżek pod GO ####
   # if (!is.na(argParse[[1]])) {
   #   file_xml_Q <- argParse$JPK_file_QUOTED
   #   CSV_dir_Q <- argParse$result_dir_QUOTED
   #
   #   CSV_dir <- paste0(export_dir, "\\", "CSV")
   #   if (!dir.exists(CSV_dir)) {
   #     dir.create(path = CSV_dir)
   #   }
   # } else {



     file_xml_Q <- shQuote(file_xml)


     CSV_dir <- paste0(export_dir, "/", "CSV")

     if (dir.exists(CSV_dir)) {
       timeNow <- NazwyPlikow_TIME

       dir.create(path = paste0(CSV_dir, "_",timeNow))
       CSV_dir <- paste0(CSV_dir, "_",timeNow)
     }

     if (!dir.exists(CSV_dir)) {
       dir.create(path = CSV_dir)
     }
     CSV_dir_Q <- shQuote(CSV_dir)


  # CSV_dir <- paste0(export_dir, "/", "CSV")
  # if (!dir.exists(CSV_dir)) {
  #   dir.create(path = CSV_dir)
  # }
 # CSV_dir_Q <- shQuote(CSV_dir)
  # export_dir <- paste0(getwd(),"/", export_dir)
  # if (!dir.exists(export_dir)) {
  #   dir.create(path = export_dir)
  # }



  #### Skrocenie typu JPK
  jpk_type_GO <- jpk_type %>%
    tolower() %>%
    str_remove(pattern = "jpk_")

  #### Komenda golang #####
  command <- paste0('jpk ', jpk_type_GO, ' --file ', file_xml_Q,' --dir ',CSV_dir_Q)
  print(command)
  if (useGObinary) {
    command <- paste0(shQuote(binary_dir),' ', jpk_type_GO, ' --file ', file_xml_Q,' --dir ',CSV_dir_Q)
    print(command)
  }

  system(command)



  #################
  #NazwyPlikow       <- list.files(path = CSV_dir, pattern = "(.txt)$")
  LokalizacjePlikow <- list.files(path = CSV_dir, pattern = "(.txt)$", full.names = T)
  LokalizacjePlikow <- str_replace_all(LokalizacjePlikow, pattern = "/", replacement = "/")
  NazwyPlikow <- str_remove(LokalizacjePlikow, pattern = fixed(paste0(CSV_dir, "/")))
  NazwyPlikow <- str_remove(NazwyPlikow, pattern = "(.txt)$")
  NazwyPlikow <- str_remove(NazwyPlikow, pattern = "/")

  print("Lokalizacaje plików to: ")
  print(LokalizacjePlikow)
  dbWriteTable(SQLiteConnection,
               name = "TYP",
               value = tibble(TYP = jpk_type),
               append = F,
               overwrite = T)
  print("Zapisano: TYP")
  for (i in 1:length(LokalizacjePlikow)) {
    Nazwa <- NazwyPlikow[i]
    Lokalizacja <- LokalizacjePlikow[i]
    col_names <- JPK_CONFIG[[jpk_type]]$Colnames[[Nazwa]]
    print(paste0("jpk_type: ", jpk_type))
    print(paste0("Nazwa: ", Nazwa))
    print(col_names)


    cat(paste0("Procesujemy:", Nazwa, "\n",
               "Z lokalizacji: ", Lokalizacja, "\n"))

    temp_read  <- tryCatch({
      read.table(
        file = Lokalizacja,
        sep = ";",
        header = F,
        dec = ".",
        quote = "",
        allowEscapes = F,
        comment.char = "",
        fill = T,
        stringsAsFactors = F,
        encoding = "UTF-8"
      )
    }, warning = function(w) {
      ret <- read.table(
        file = Lokalizacja,
        sep = ";",
        header = F,
        dec = ".",
        quote = "",
        allowEscapes = F,
        comment.char = "",
        fill = T,
        stringsAsFactors = F,
        encoding = "UTF-8"
      )
      return(ret)
    }, error = function(e) {
      dd <- data.frame(matrix(ncol = length(col_names), nrow = 0))
      colnames(dd) <- col_names

      return(dd)
    }, finally = {

    })

    temp_read <- as.tibble(temp_read)
    colnames(temp_read) <- col_names

    temp_read <- AddMissingColsAndFillWith0(df = temp_read, ALL_COLS = col_names)

    temp_read <- convertCharColsToNum(df = temp_read, guess = T)
    print("Kilka pierwszych wierszy tabeli: ")
    print(head(temp_read))
    dbWriteTable(conn = SQLiteConnection, name = Nazwa, value = temp_read, append = T)
    print(paste0("Zapisano: ", Nazwa))
  }
}
