#' @title Export tabel pliku SQLite do Excela (xlsx)
#'
#' @description Dodać
#' @param file_SQL path to sqlitefile
#' @param file_excel where you want o save SQLite file
#'
#' @return xlsx file with JPK tables
#' @export
#'
#'
SQLiteToExcel <- function(file_SQL = NA,
                          file_excel = NA) {

  if (!is.character(file_SQL)|is.na(file_SQL)) {
    stop("You have to pass path to SQLite file")
  }

  if (is.na(file_excel)) {
    file_excel <- stringr::str_replace(file_SQL, pattern = "(\\.sqlite)$", replacement = "\\.xlsx")
  }


  RSQLite::dbConnect(RSQLite::SQLite(), file_SQL) -> myDB
  sprintf("Połączono z bazą danych %s", paste0(getwd(),"/",file_SQL))

  tabsNames <- dbListTables(myDB)
  tabsList <- vector("list", length = length(tabsNames))

  k <- 1
  maxRow <- 0
  for (tab in tabsNames) {
    temp <-  tbl(myDB, tab) %>%
      collect()

    tabsList[[k]] <- temp
    maxRow <- max(maxRow, nrow(temp))
    k <- k + 1
  }

  if (maxRow < 1000 * 1000) {
    writexl::write_xlsx(tabsList, path = file_excel)
  } else {
    stop("Conajmniej jedna z tabel ma więcej niż milion wierszy")
  }
}
