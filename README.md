# JPKr

### Wstęp
Pakiet JPKr służy do pracy z jednolityki plikami kontrolnymi w R. Pakiet pozwala na:

1. Wczytanie pliku .xml z JPK
2. Wyodrębnienie tabel zawartych w JPK i w zależności od wielkości:
 a) (do 50mb) export do excela (.xlsx) i do pamięci R (.Rdata)
 b) (powyżej 50mb) export do bazy danych w SQLite (wymagane poprzez ograniecznie wczytania dużych plików do pamięci RAM)
3. Zwalidowanie sum kontrolnych
4. Szereg analiz, służycych do wykrycia potencjalnych nadyżyć i odchyleń w pliku

### Język

Ponieważ pakiet posłuży do analiz polskich danych to dokumentacja repozytorium + dokumentacja funkcji będzie w języku polskim. Z racji, że większość funkcji, które używane są w R ma nazwy w języku angielskim, to nazwy funkcji i parametrów bedą w jezyku ang.

