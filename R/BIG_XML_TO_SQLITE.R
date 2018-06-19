###1. xml2::read_xml() ####
###2. guessJpkType####
###3. Read number of rows in tables####
###4. Prepare sqlite base####
###5. Read, add missing cols, write to db####
###6. ####


BIG_XML_TO_SQLITE <- function(file_xml = "", file_SQL = "Plik_JPK.sqlite") {

  ##JPK_FA#####
  xml2::read_xml(file_xml, encoding = "UTF-8") %>%
    xml_find_first("//d1:FakturaCtrl") %>%
    as_list() %>%
    unlist() %>%
    t() %>%
    as.tibble() %>%
    select(LiczbaFaktur) %>%
    unlist() %>%
    unname() %>%
    as.numeric() -> JPK_FA_LiczbaFaktur

  xml2::read_xml(file_xml, encoding = "UTF-8") %>%
    xml_find_first("//d1:FakturaWierszCtrl") %>%
    as_list() %>%
    unlist() %>%
    t() %>%
    as.tibble() %>%
    select(LiczbaWierszyFaktur) %>%
    unlist() %>%
    unname() %>%
    as.numeric() -> JPK_FA_LiczbaWierszyFaktur


  mydb <- dbConnect(RSQLite::SQLite(), "XML7.sqlite")

RSQLite::dbConnect(RSQLite::SQLite(), file_SQL) -> myDB

}
