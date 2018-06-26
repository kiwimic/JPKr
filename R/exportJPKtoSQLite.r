
#' exportJPKtoSQLite is doing parsing JPK elemens for example from "Faktura" table of JPK_FA file single record is between this characters "<Faktura typ=\"G\">","</Faktura>",
#' function generate SQLite file with tables with records of JPK file.
#' @param file_xml path to xml file
#' @param file_SQL name of sqlfile you want to create 'remember to add .sqlite at the end'
#' @param bufor_size size of single instert of records you want to write to sqlite base. Default is 1000
#'
#' @return
#' @export
#'
#' @examples
exportJPKtoSQLite <-
  function(file_xml = "",
           file_SQL = "Plik_JPK.sqlite",
           bufor_size = 1000) {


    ##0.0.1 TODO#########################################
    ##0.0.1.1 Pobrać nagłowek i guessJpkType() #####
    ##0.0.1.2 Uniezależnić kod od rodzaju pliku JPK####
    ##Np. JPK_FA[[Ctrl]] <- list("//d1:FakturaCtrl", ####
    ##"//d1:FakturaWierszCtrl") ####
    ## JPK_FA_STRUKTURA <- list(Ctrl, Elementy (st, kc))
    ##0.1.0 Inicjacja bazy danych SQLite (myDB)#####
    RSQLite::dbConnect(RSQLite::SQLite(), file_SQL) -> myDB

    ##0.1.1 wczytanie JPK_FA#####
    JPK_UNKNOWN <- xml2::read_xml(file_xml, encoding = "UTF-8")
    JPK_TYPE <- getJpkType(JPK_UNKNOWN)
    #JPK_CONFIG_temp <- JPK_CONFIG[[JPK_TYPE]]
    #JPK_TYPE <- "JPK_FA"
    ##0.2 Sumy kontrolne ####
    ##TODO docelowo wprowadzić pętle po parametrze w configu
    ## W configu zaszyte są lokalizacje i nazwy zmiennych
    for (z in 1:length(JPK_CONFIG[[JPK_TYPE]][["Ctrl"]])) {
      dbWriteTable(myDB,
                   JPK_CONFIG[[JPK_TYPE]]$Ctrl[[z]][1],
                   getControlSums(JPK_UNKNOWN, xPath = JPK_CONFIG[[JPK_TYPE]]$Ctrl[[z]][2]),
                   append = F)


    }
      ## Aby uniknąć ponowe wczytywanie
      readLines(file_xml, encoding = "UTF-8") %>%
      paste(collapse = "\n") %>%
      str_remove_all(pattern = "tns:") %>%
      str_replace_all(pattern = ">(\\s+)?<", replacement = ">\n<") %>%
      str_split(pattern = "\n") %>%
      unlist() -> JPK_UNKNOWN_text

    for (j in 1:length(JPK_CONFIG[[JPK_TYPE]][["Tables"]])) {

      linesToSQLite(linesOfJPK = JPK_UNKNOWN_text,
                    bufor_size = bufor_size,
                    SQLiteConnection = myDB,
                    table_name = JPK_CONFIG[[JPK_TYPE]]$Tables[[j]][1],
                    record_start = JPK_CONFIG[[JPK_TYPE]]$Tables[[j]][2],
                    record_end = JPK_CONFIG[[JPK_TYPE]]$Tables[[j]][3],
                    removeStringfromColnames = JPK_CONFIG[[JPK_TYPE]]$Tables[[j]][4],
                    colnamesList = JPK_CONFIG[[JPK_TYPE]]$Colnames[[j]]
                    )

    }
    dbDisconnect(myDB)

    #0.9999 KONIEC FUNKCJI#####
    ######XXXXXXXXXXXXXXXXXXXXXXXXXX#########
    ## 0.3 Wczytanie JPK jako text + Struktyryzacja#####
    ## 0.3.1 Wczytanie JPK ####
  }
