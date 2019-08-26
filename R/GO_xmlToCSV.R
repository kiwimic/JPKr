
#' Go_xmlToCSV
#'
#' @param file_xml path to JPK .xml file
#' @param export_dir dir where csv files will be returned
#' @param jpk_type type of JPK file for example jpk_vat, jpk_fa, jpk_mag..
#' @param uniqueNamePart if there are already csv in directory, this will be added to name of folder
#' @param pathToBinary pathToBinery of go file, default Sys.getenv(x = "JPKr_GO_BINARY")
#'
#' @return
#' @export
#'
#' @examples
 GO_xmlToCSV <- function(file_xml = "",
                         export_dir = "",
                         jpk_type = JPK_TYPE,
                         uniqueNamePart = stringr::str_remove_all(string = Sys.time(), pattern = "[^0-9]"),
                         pathToBinary = Sys.getenv(x = "JPKr_GO_BINARY")) {

   if (!checkIfJPKbinaryExists(pathToBinary = pathToBinary)) {
     stop(sprintf("Go binary %s don't exists in this location", pathToBinary))
   }

     file_xml_Q <- shQuote(file_xml)
     CSV_dir <- paste0(export_dir, "/", "CSV")

     if (dir.exists(CSV_dir)) {
       timeNow <-
       dir.create(path = paste0(CSV_dir, "_", uniqueNamePart))
       CSV_dir <- paste0(CSV_dir, "_",uniqueNamePart)
     }

     if (!dir.exists(CSV_dir)) {
       dir.create(path = CSV_dir)
     }
     CSV_dir_Q <- shQuote(CSV_dir)


  #### Skrocenie typu JPK
  jpk_type_GO <- jpk_type %>%
    tolower() %>%
    str_remove(pattern = "jpk_")

  #### Komenda golang #####
  command <- paste0(shQuote(pathToBinary),' ', jpk_type_GO, ' --file ', file_xml_Q,' --dir ',CSV_dir_Q)
  print(command)


  system(command)

  print(paste0("Poprawnie zapisano pliki w: ", CSV_dir))

  return(list(CSV_dir = CSV_dir,
              pathOfCSVfiles = list.files(path = CSV_dir, full.names = T, pattern = ".csv$"),
              command = command,
              uniqueNamePart = uniqueNamePart,
              pathToBinary = pathToBinary,
              jpk_type = jpk_type))

}
