# Hello, world!
#
# This is an function that convert character cols from dataframe to numeric.
# You have to pass colnames to convert as argument colsToConv
#
# You can learn more about package authoring with RStudio at:
#
#   http://r-pkgs.had.co.nz/
#
# Some useful keyboard shortcuts for package authoring:
#
#   Build and Reload Package:  'Ctrl + Shift + B'
#   Check Package:             'Ctrl + Shift + E'
#   Test Package:              'Ctrl + Shift + T'
library(stringr)


##0.4 Wektora wersja funkcji do walidacji NIP (działa w ramkach danych#########
validationOfPolishNIP <- Vectorize(FUN = function(NIP) {
  ret <- FALSE

  if (nchar(NIP) < 10) {
    ret <- FALSE
  } else {
    NIP <- str_extract_all(NIP,  pattern = "[0-9]", simplify = T)
    NIP <- as.numeric(NIP)
    if (length(NIP) != 10) {
      ret <- FALSE
    } else {
      walidationVector <- c(6, 5, 7, 2, 3, 4, 5, 6, 7)
      STEP1 <- NIP[1:9] * walidationVector
      STEP2 <- sum(STEP1)
      STEP3 <- STEP2%%11
      if (STEP3 == NIP[10]) {
        ret <- TRUE
      }
    }

  }

  return(ret)
}, "NIP")

