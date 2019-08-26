#' @title exportJPKtoSQLite main function.
#'
#' @description exportJPKtoSQLite is doing parsing JPK elemens for example from "Faktura" table of JPK_FA file single record is between this characters "<Faktura typ=\"G\">","</Faktura>",
#' function generate SQLite file with tables with records of JPK file.
#' @param file_xml path to xml file
#' @param file_SQL name of sqlfile you want to create 'remember to add .sqlite at the end'
#' @param export_dir dir where you want o save SQLite file
#' @param bufor_size size of single instert of records you want to write to sqlite base. Default is 10000
#' @param pathToBinary pathToBinery of go file, default Sys.getenv(x = "JPKr_GO_BINARY")
#'
#' @return SQLite db filled with parsed JPK file
#' @export
#'
#'
exportJPKtoSQLite <-
  function(file_xml = "",
           file_SQL = "Plik_JPK.sqlite",
           export_dir = "",
           bufor_size = 10000,
           pathToBinary = Sys.getenv(x = "JPKr_GO_BINARY")) {

    if (!checkIfJPKbinaryExists(pathToBinary = pathToBinary)) {
      stop(sprintf("Go binary %s don't exists in this location", pathToBinary))
    }

    time_start <- Sys.time()
    NazwyPlikow_TIME <- str_remove_all(time_start, pattern = "[^0-9]")

    if (!dir.exists(export_dir)) {
      dir.create(path = export_dir)
    }
    ##0.0.1 TODO#########################################
    ##0.0.1.1 Pobrać nagłowek i guessJpkType() #####
    ##0.0.1.2 Uniezależnić kod od rodzaju pliku JPK####
    ##Np. JPK_FA[[Ctrl]] <- list("//d1:FakturaCtrl", ####
    ##"//d1:FakturaWierszCtrl") ####
    ## JPK_FA_STRUKTURA <- list(Ctrl, Elementy (st, kc))
    ##0.1.0 Inicjacja bazy danych SQLite (myDB)#####
    if (file.exists(paste0(export_dir,"/",file_SQL))) {
      file_SQL <- str_replace(file_SQL,
                              pattern = "\\.sqlite",
                              replacement = paste0("_", NazwyPlikow_TIME, ".sqlite"))
    }

    RSQLite::dbConnect(RSQLite::SQLite(), paste0(export_dir,"/",file_SQL)) -> myDB
    sprintf("Stworzono bazę danych w lokalizacji %s", paste0(export_dir,"/",file_SQL))

    ##0.1.1 wczytanie JPK_FA#####
    #JPK_UNKNOWN <- xml2::read_xml(file_xml, encoding = "UTF-8")
    JPK_TYPE <- JPKr::getPointerOfXML(JPK_file) %>% JPKr::getJpkType()
    print("Dodanie pointera trwało: ")
    print( Sys.time() - time_start)
    time_v1 <- Sys.time()


     GO_xmlToCSV(
        file_xml = file_xml,
        export_dir = export_dir,
        jpk_type = JPK_TYPE,
        uniqueNamePart = stringr::str_remove_all(string = Sys.time(), pattern = "[^0-9]"),
        pathToBinary = pathToBinary
      ) -> paramsToPassLater

     print(paramsToPassLater)

     csvToSQLite(pathOfCSVfiles = paramsToPassLater$pathOfCSVfiles,
                 SQLiteConnection = myDB,
                 jpk_type = paramsToPassLater$jpk_type)



    dbDisconnect(myDB)
    print("Całość trwała: ")
    print(Sys.time() - time_start)
    return(file_SQL)
    #0.9999 KONIEC FUNKCJI#####
    ######XXXXXXXXXXXXXXXXXXXXXXXXXX#########
  }
