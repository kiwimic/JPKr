#
# suppressPackageStartupMessages(library("JPKr", quietly = T))
#
# cat("\n\n0. Opis\n")
# cat("Jest to skrypt uruchomialny do kompletu wczytania, zapisania,\n")
# cat("przestowania i zapisania wyników dla 1 pliku JPK.\n")
# cat("Skrypt korzysta z 2 języków:\n")
# cat("-R ok. 95% kodu i funkcjalności jest w nim napisane (analiza danych testy itp.),\n")
# cat("-GO szybkie wczytywanie bardzo dużych plików JPK > 200MB do kilku GB plików i przygotowanie ich pod analizę\n")
#
# ## 0. Opis ####
# # Jest to skrypt uruchomialny do kompletu wczytania, zapisania,
# # przestowania i zapisania wyników dla 1 pliku JPK
#
# ### 1. Wybierz plik JPK (format .xml lub .txt) ####
# cat("\n\n\n1. Wybierz plik JPK (format .xml, lub .txt)\n")
# JPK_file <- choose.files(caption = "Wybierz plik JPK",
#                          multi = F)
#
# JPK_file_QUOTED <- shQuote(JPK_file)
#
#
# ### 2. Wybierz lokalizację, gdzie mają zostać zapisany wczytany plik i wyniki testów ####
# cat("2. Wybierz lokalizację, gdzie mają zostać zapisany wczytany plik i wyniki testów\n")
# result_dir <- choose.dir(caption = "Wybierz lokalizacje dla wyników")
# result_dir_QUOTED <- shQuote(result_dir)
#
# typJPK <- JPKr::getPointerOfXML(JPK_file) %>% JPKr::getJpkType()
# typJPK_go <- typJPK %>%
#   tolower() %>%
#   str_remove(pattern = "jpk_")
# command <- paste0('jpk ', typJPK_go, ' --file ',JPK_file_QUOTED, "'",' --dir ', "'",result_dir_QUOTED, "'")
#
# system(command)
#
# exportJPKtoSQLite(file_xml = JPK_file,
#                   export_dir = result_dir,
#                   useGolang = T,
#                   useGObinary = F
# ) -> file_SQL
#
# doALLtests(SQLite_file = file_SQL, export_dir = result_dir)
