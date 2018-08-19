library("JPKr")
## 0. Opis ####
# Jest to skrypt uruchomialny do kompletu wczytania, zapisania,
# przestowania i zapisania wyników dla 1 pliku JPK

### 1. Wybierz plik JPK (format .xml lub .txt) ####
JPK_file <- choose.files(caption = "Wybierz plik JPK",
                         multi = F
)

### 2. Wybierz lokalizację, gdzie mają zostać zapisany wczytany plik i wyniki testów ####
result_dir <- choose.dir(caption = "Wybierz lokalizacje dla wyników")

useGO <- winDialog(type = "yesno",
          message = "Czy użyć GO?")
if (useGO == "YES") {
  print("Użyto GO")
} else {
  print("Nieużyto GO :)")
}


### 3. Wczytaj i zapisz do sqlite plik JPK ####
# JPKr::exportJPKtoSQLite(file_xml = JPK_file,
#                         file_SQL = "JPK.sqlite",
#                         export_dir = result_dir
# )
#system2('jpk', args = c('fa', '--file', JPK_file, '--dir', result_dir))

