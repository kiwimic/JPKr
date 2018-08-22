
#' endTimePrediction Służy do obliczenia ile pozostało czasu przy wczytaniu pliki.
#'
#' @param start numericPositict
#' @param index numeric index from loop like 1,2,3, ... n
#' @param lastIndex last index. end of loop
#' @param TimeFromStart T/F For measuring not how much time left, but how much time passed
#'
#' @return character string with prediction of time left
#' @export
#'
#'
endTimePrediction <- function(start, index, lastIndex, TimeFromStart = F) {
  start <- as.numeric(start)
  now <- as.numeric(Sys.time())
  round(now - start) -> time_diff
  time_diff/index -> timePerIndex
  IndexesToGo <- lastIndex - index
  secondToFinish <- round(IndexesToGo * timePerIndex)

  if (secondToFinish < 60) {
    ret <- sprintf("Pozostało %d sekund", secondToFinish)
  } else if (secondToFinish < 60 * 60){
    mins <- floor(secondToFinish/60)
    secs <- secondToFinish %% 60
    ret <- sprintf("Pozostało %d minut i %d sekund", mins, secs)
  } else {
    hours <- floor(secondToFinish/3600)
    mins <- secondToFinish - hours * 3600
    mins <- floor(mins/60)
    secs <- secondToFinish %% 60

    ret <- sprintf("Pozostało %d godzin %d minut i %d sekund", hours, mins, secs)
  }

  if (TimeFromStart) {
    if (time_diff < 60) {
      ret <- sprintf("Mineło %d sekund", time_diff)
    } else if (time_diff < 60 * 60){
      mins <- floor(time_diff/60)
      secs <- time_diff %% 60
      ret <- sprintf("Mineło %d minut i %d sekund", mins, secs)
    } else {
      hours <- floor(time_diff/3600)
      mins <- time_diff - hours * 3600
      mins <- floor(time_diff/60)
      secs <- time_diff %% 60

      ret <- sprintf("Mineło %d godzin %d minut i %d sekund", hours, mins, secs)
    }
  }

  return(ret)
}
