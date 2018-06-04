


# This is an function that convert character cols from dataframe to numeric.
# You have to pass colnames to convert as argument colsToConv
#
# You can learn more about package authoring with RStudio at:
#
#   http://r-pkgs.had.co.nz/
#
library(tibble)
convertCharColsToNum <- function(df, colsToConv, guess = F) {
  if (!(is.data.frame(df) | is.tibble(df))) {
    stop(
      sprintf(
        "Please pass data.frame or tibble as df argument Argument you just pass is class: %s",
        class(df)
      )
    )
  }

  if (guess) {
    df2 <- suppressWarnings(as.tibble(lapply(df, as.numeric)))
    sumOfNA <- apply(df2, 2, function(x) {
      return(sum(is.na(x)))
    })
    sumOfNA == 0
    df[,sumOfNA==0] <- as.tibble(lapply(df[,sumOfNA == 0], as.numeric))
    df <- as.tibble(df)
  } else {
    df[, colsToConv] <- apply(df[, colsToConv], 2,   function(x) {
      return(as.numeric(x))
    })
  }
  return(df)
}



################


