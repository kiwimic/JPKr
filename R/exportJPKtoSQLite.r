
#' exportJPKtoSQLite is doing parsing JPK elemens for example from "Faktura" table of JPK_FA file single record is between this characters "<Faktura typ=\"G\">","</Faktura>",
#' function generate SQLite file with tables with records of JPK file.
#' @param file_xml path to xml file
#' @param file_SQL name of sqlfile you want to create 'remember to add .sqlite at the end'
#' @param export_dir dir where you want o save SQLite file
#' @param bufor_size size of single instert of records you want to write to sqlite base. Default is 1000
#' @param UseGolang T/F param to use golang for faster parsing xml files. 400mb file on my PC is 3h with pure R, and 1,5miniwht GO
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
           useGolang = F,
           argParse = NA,
           useGObinary = F,
           binary_dir = 'C:\\msiwik\\Desktop\\FOLDER R\\JPK\\jpk.exe') {

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


    ##0.1.1 wczytanie JPK_FA#####
    JPK_UNKNOWN <- xml2::read_xml(file_xml, encoding = "UTF-8")
    print("Dodanie pointera trwało: ")
    print( Sys.time() - time_start)
    time_v1 <- Sys.time()
    JPK_TYPE <- getJpkType(JPK_UNKNOWN)

      ## Aby uniknąć ponowe wczytywanie
    if (useGolang) {

      GO_xmlToSQLite(
        file_xml = file_xml,
        SQLiteConnection = myDB,
        export_dir = export_dir,
        bufor_size = 10000,
        jpk_type = JPK_TYPE,
        NazwyPlikow_TIME = NazwyPlikow_TIME,
        useGObinary = useGObinary,
        binary_dir = 'C:\\msiwik\\Desktop\\FOLDER R\\JPK\\jpk.exe'
      )

    } else {
      readLines(file_xml, encoding = "UTF-8") %>%
        paste(collapse = "\n") %>%
        str_remove_all(pattern = "tns:") %>%
        str_replace_all(pattern = ">(\\s+)?<", replacement = ">\n<") %>%
        str_split(pattern = "\n") %>%
        unlist() -> JPK_UNKNOWN_text

      print("Przerobienie xml do readlines trwało: ")
      print(Sys.time() - time_v1)

      ##0.1.2 Dodanie tabeli z typem JPK #####
      dbWriteTable(myDB,
                   name = "TYP",
                   value = tibble(TYP = JPK_TYPE),
                   append = F,
                   overwrite = T)
      #JPK_CONFIG_temp <- JPK_CONFIG[[JPK_TYPE]]
      #JPK_TYPE <- "JPK_FA"
      ##0.2 Sumy kontrolne ####
      ##TODO docelowo wprowadzić pętle po parametrze w configu
      ## W configu zaszyte są lokalizacje i nazwy zmiennych
      for (z in 1:length(JPK_CONFIG[[JPK_TYPE]][["Ctrl"]])) {
        time_v2 <- Sys.time()
        dbWriteTable(myDB,
                     JPK_CONFIG[[JPK_TYPE]]$Ctrl[[z]][1],
                     getControlSums(JPK_UNKNOWN_text, pattern = JPK_CONFIG[[JPK_TYPE]]$Ctrl[[z]][1]),
                     append = F)

        print(paste0("Dodanie sumy kontrolnej: ", JPK_CONFIG[[JPK_TYPE]]$Ctrl[[z]][1], " trwało: "))
        print(Sys.time() - time_v2)
      }

      print("Teraz następuje export tabel do pliki SQLite")
      for (j in 1:length(JPK_CONFIG[[JPK_TYPE]][["Tables"]])) {

        print(paste0("Wczytywanie: ", JPK_CONFIG[[JPK_TYPE]]$Tables[[j]][1]))
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
    }
    dbDisconnect(myDB)
    print("Całość trwała: ")
    print(Sys.time() - time_start)

    #0.9999 KONIEC FUNKCJI#####
    ######XXXXXXXXXXXXXXXXXXXXXXXXXX#########
    ## 0.3 Wczytanie JPK jako text + Struktyryzacja#####
    ## 0.3.1 Wczytanie JPK ####
  }
