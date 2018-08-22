library(stringr)
library(tibble)

#' rmCharNULLfromDF In JPK files NA values are like character 'NULL'. This funcion replaces 'NULL's' with '0'
#'
#' @param df data frame JPK record
#'
#' @return df with replaced all character NULL's to 0
#' @export
#'
#'
rmCharNULLfromDF <- function(df) {
  if (!(is.data.frame(df)|is.tibble(df))) {
    stop(sprintf("Please pass data.frame or tibble as df argument Argument you just pass is class: %s", class(df)))
  }

  df[, 1:ncol(df)] <- apply(df[, 1:ncol(df)], 2,   function(x) {
    return(str_replace_all(x,
                           pattern = "^NULL$",
                           replacement = "0"))
  })
  return(df)
}
