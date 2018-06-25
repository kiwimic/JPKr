
#' Title
#'
#' @param file_xml
#' @param file_SQL
#' @param bufor_size
#'
#' @return
#' @export
#'
#' @examples
BIG_XML_TO_SQLITE <-
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



    for (j in 1:length(JPK_CONFIG[[JPK_TYPE]][["Tables"]])) {

      linesToSQLite(file_xml = file_xml,
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
