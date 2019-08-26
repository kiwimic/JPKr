
#' Title
#'
#' @param pathOfCSVfiles full path to csv files
#' @param SQLiteConnection connection to db SQLite
#' @param jpk_type type of jpk like jpk_vat, jpk_fa, jpk_mag
#'
#' @return
#' @export
#'
#' @examples
csvToSQLite <- function(pathOfCSVfiles = "",
                        SQLiteConnection = myDB,
                        jpk_type = NA) {



  # pathOfCSVfiles <- c(
  #  "C:\\Users\\msiwik\\Desktop\\TESTE\\CSV_20190423172852/Faktura.csv",
  #  "C:\\Users\\msiwik\\Desktop\\TESTE\\CSV_20190423172852/FakturaCtrl.csv" ,
  #  "C:\\Users\\msiwik\\Desktop\\TESTE\\CSV_20190423172852/FakturaWiersz.csv",
  #  "C:\\Users\\msiwik\\Desktop\\TESTE\\CSV_20190423172852/FakturaWierszCtrl.csv",
  #  "C:\\Users\\msiwik\\Desktop\\TESTE\\CSV_20190423172852/Naglowek.csv" )


  NazwyPlikow <- str_extract(pathOfCSVfiles, pattern= "/[A-Za-z]+.csv") %>%
    str_remove(pattern = "\\.csv$") %>%
    str_remove(pattern = "/")


  print("Lokalizacaje plików to: ")
  print(pathOfCSVfiles)

  print(paste0("plik JPK: ", jpk_type))
  dbWriteTable(SQLiteConnection,
               name = "TYP",
               value = tibble(TYP = jpk_type),
               append = F,
               overwrite = T)

  print("Zapisano tabelę: TYP")

  for (i in 1:length(pathOfCSVfiles)) {

    Nazwa <- NazwyPlikow[i]
    Lokalizacja <- pathOfCSVfiles[i]
    col_names <- JPK_CONFIG[[jpk_type]]$Colnames[[Nazwa]]
    print(paste0("jpk_type: ", jpk_type))
    print(paste0("Nazwa: ", Nazwa))


    cat(paste0("Procesujemy:", Nazwa, "\n",
               "Z lokalizacji: ", Lokalizacja, "\n"))

    temp_read  <- tryCatch({
      read.table(
        file = Lokalizacja,
        sep = ";",
        header = T, ## Dodałem nazwy kolumn więc nie potrzebne nazwy kolumn
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
        header = T,## Dodałem nazwy kolumn więc nie potrzebne nazwy kolumn
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
    if (sum(colnames(temp_read)==col_names) == length(col_names)) {
      print("Nazwy kolumn z pliku CSV zgadzają się z nazwami kolumn z JPK_CONFIG")
    } else {
      print("Cols GO:")
      print(colnames(temp_read))
      print("Cols JPK_CONFIG:")
      print(col_names)
      colnames(temp_read) <- col_names
    }


    temp_read <- AddMissingColsAndFillWith0(df = temp_read, ALL_COLS = col_names)

    temp_read <- convertCharColsToNum(df = temp_read, guess = T)
    print("Kilka pierwszych wierszy tabeli: ")
    print(head(temp_read))
    dbWriteTable(conn = SQLiteConnection, name = Nazwa, value = temp_read, append = T)
    print(paste0("Zapisano: ", Nazwa))
  }
}
