# JPKr

### Wstęp
Pakiet JPKr służy do pracy z jednolityki plikami kontrolnymi w R. Pakiet pozwala na:

1. Wczytanie pliku .xml z JPK
2. Wyodrębnienie tabel zawartych w JPK i w zależności od wielkości:
 a) (do 50mb) export do excela (.xlsx) i do pamięci R (.Rdata)
 b) (powyżej 50mb) export do bazy danych w SQLite (wymagane poprzez ograniecznie wczytania dużych plików do pamięci RAM)
3. Zwalidowanie sum kontrolnych
4. Szereg analiz, służycych do wykrycia potencjalnych nadyżyć i odchyleń w pliku

### TODO dla wersji 0.2.0

1) Wczytanie pliku JPK_VAT.xml do Bazy SQLite (100%)
  a) ZakupWiersz (100%)
  b) ZakupCtrl (100%)
  c) SprzedazWiersz (100%)
  d) SprzedazCtrl (100%)
  
2) Wczytanie pluku JPK_FA.xml do Bazy SQLite (100%)
  a) FakturaWiersz (100%)
  b) FakturaWierszCtrl (100%)
  c) Faktura (100%)
  d) FakturaCtrl (100%)

3) W przypadku gdy liczba rekordów w każdej z baz jest mniejsza niż < 500tys. Export do pliku xlsx (IN PROGRESS)

4) Raport testów: (IN PROGRESS)
  a) Walidacja sum kontrolnych
  b) Walidacja obliczeń podatków
  c) ...
  d) Summary pochodzenie NIP. (50%)
  e) ...
  f) itd... :)

5) Dodanie walidacji do parametrów funkcji class == x itp. (IN PROGRESS)

### Język

Ponieważ pakiet posłuży do analiz polskich danych to dokumentacja repozytorium + dokumentacja funkcji będzie w języku polskim. Z racji, że większość funkcji, które używane są w R ma nazwy w języku angielskim, to nazwy funkcji i parametrów bedą w jezyku ang.

