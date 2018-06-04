
# This is an function that convert character cols from dataframe to numeric.
# You have to pass colnames to convert as argument colsToConv
#
# You can learn more about package authoring with RStudio at:
#
#   http://r-pkgs.had.co.nz/
#
Test_ValidateControlSums <- function(V1, V2, msg, onlyWarning = F) {
  if (V1 != V2) {
    if (onlyWarning) {
      warning(sprintf(msg, V1, V2))
    } else {
      stop(sprintf(msg, V1, V2))
    }
  }
}

