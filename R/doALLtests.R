
#' @title doALLtests
#'
#' @description bla bla bla
#' @param testReturn must be list which is returned after one of test fun test001, 002 ...
#'
#' @return exported file
#' @export
#'
#'
doALLtests <- function(SQLite_file = NA, export_dir, customFileName, WybraneTesty = 1:100) {

  Nchar<-nchar(export_dir)
  lastSing <- str_sub(export_dir, Nchar, Nchar)

  if (sum(lastSing %in% c("\\", "/")) == 0) {
    export_dir <- paste0(export_dir, "/")
  }

  CtrlList <- list("SprzedazWiersz" = "SprzedazCtrl",
                   "ZakupWiersz" = "ZakupCtrl",
                   "FakturaWiersz" = "FakturaWierszCtrl",
                   "Faktura" = "FakturaCtrl",
                   "MMWartosc" = "MMCtrl",
                   "RWWartosc" = "RWCtrl",
                   "PZWartosc" = "PZCtrl",
                   "WZWartosc" = "WZCtrl",
                   "WyciagWiersz"= "WyciagCtrl")

  NumerDoc <- list("SprzedazWiersz" = "DowodSprzedazy",
                   "ZakupWiersz" = "DowodZakupu",
                   "FakturaWiersz" = "P_2B",
                   "Faktura" = "P_2A",
                   "MMWartosc" = "NumerMM",
                   "RWWartosc" = "NumerRW",
                   "PZWartosc" = "NumerPZ",
                   "WZWartosc" = "NumerWZ"
                   )

  fullPath <- normalizePath(paste0(export_dir, SQLite_file))
  print(fullPath)
  RSQLite::dbConnect(RSQLite::SQLite(), fullPath) -> myDB
  tbl_list <- dbListTables(myDB)

  jpk_type <- tbl(myDB, "TYP") %>% collect() %>% unlist() %>% unname()

  allTables <- c("Faktura",
                 "FakturaWiersz",
                 "SprzedazWiersz",
                 "ZakupWiersz",
                 "MMWartosc",
                 "RWWartosc",
                 "PZWartosc",
                 "WZWartosc",
                 "WyciagWiersz"
  )

  tbl_to_analyze <- allTables[allTables %in% tbl_list]
  i <- 1
  for (tab in tbl_to_analyze) {
    print(tab)
    data <- tbl(myDB, tab) %>% collect()
    ctrlSums <- tbl(myDB, CtrlList[[tab]]) %>% collect()

    if (2 %in% WybraneTesty) {
      test002(data = data, controlSumsFromFile = ctrlSums, tableName = tab) %>%
        testExport(export_dir = export_dir, customFileName = paste0(tab, "_",  "test002"))
    }

    if (1 %in% WybraneTesty) {
    test001(data = data) %>%
      testExport(export_dir = export_dir, customFileName = paste0(tab, "_",  "test001"))
    }


    if (3 %in% WybraneTesty) {
    if (!tab  %in% c("FakturaWiersz",
                     "MMWartosc",
                     "RWWartosc",
                     "PZWartosc",
                     "WZWartosc",
                     "WyciagWiersz")) {
      test003(data = data, tableName = tab) %>%
        testExport(export_dir = export_dir, customFileName = paste0(tab, "_",  "test003"))
    }
    }


    if (4 %in% WybraneTesty) {

      test004(data = data,  tableName = tab) %>%
        testExport(export_dir = export_dir, customFileName = paste0(tab, "_",  "test004"))
    }

    if (5 %in% WybraneTesty) {
      if (!tab  %in% c("FakturaWiersz",
                       "MMWartosc",
                       "RWWartosc",
                       "PZWartosc",
                       "WZWartosc",
                       "WyciagWiersz")) {
        test005(data = data[[NumerDoc[[tab]]]]) %>%
          testExport(export_dir = export_dir, customFileName = paste0(tab, "_",  "test005"))
      }
    }


  }
}
