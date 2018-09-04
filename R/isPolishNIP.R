library(stringr)


## Wektorowa wersja funkcji do walidacji NIP (działa w ramkach danych)#########
#' Title function checks if NIP number 'Polish company indetyfication number' is from Poland 'TRUE' or not 'FALSE'
#'
#' @param NIP
#'
#' @return logical
#' @export
#'
#' @examples validatevalidationOfPolishNIP
isPolishNIP <- Vectorize(FUN = function(NIP) {
  ret <- FALSE
 if (!is.na(NIP)) {
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
 }

  return(ret)
},vectorize.args = "NIP",
  USE.NAMES = F)

