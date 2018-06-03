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
library(tibble)

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
