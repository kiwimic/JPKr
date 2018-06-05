library(tibble)
#' convertCharColsToNum
#'
#' @param df df of wchich cols you want to convert
#' @param colsToConv if guess is False, you have to pass list of cols by names like c("K_10", "K_15")
#' @param guess logical if guess is True, then function will guess automatically which columns have only numbers and have to be converted to numeric
#'
#' @return returns tibble (kind of data.frame) where cols which are only numeric (but class character), are converted to numeric
#'
#'
#' @seealso \code{\link{as.tibble}}
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


