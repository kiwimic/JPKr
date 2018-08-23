
#' parseInvoiceNumbers
#' Sluzy do zweryfikowania czy sa luki w fakturach
#' #'
#' @param data must be vector with invoice numbers
#'
#' @return data frames with gaps
#'
#'
#' @export
parseInvoiceNumbers <- function(data) {
  data <- str_to_upper(data)


  tempList <-
    vector("list", length = length(JPK_CONFIG$InvoicePatterns))
  matchlist <-
    vector("list", length = length(JPK_CONFIG$InvoicePatterns))
  dataToAnalyze <- tibble()

  for (i in 1:(length(JPK_CONFIG$InvoicePatterns))) {
    tempList[[i]] <-
      str_detect(data, pattern = JPK_CONFIG$InvoicePatterns[i])
    matchlist[[i]] <-
      str_match_all(data[tempList[[i]]], pattern = JPK_CONFIG$InvoicePatterns[i])
  }
  score <- lapply(tempList, function(x) {
    sum(x)
  })
  best <- which.max(score)

  patternToMatch <- JPK_CONFIG$InvoicePatterns[best]

  undetected <- data[!str_detect(data, pattern = patternToMatch)]

  dataToAnalyze <- matchlist[[best]]  %>%
    unlist() %>%
    matrix(ncol = max(sapply(matchlist[[best]], length), na.rm = T), byrow = T) %>%
    as.tibble()

  seqNumberCol <- apply(dataToAnalyze[,-1],MARGIN = 2, function(x) {
    return(length(unique(x))/length(x))
  }) %>%
    which.max()

  ret <- list(
    pattern = patternToMatch,
    scoreMatrix = score,
    best = best,
    matchlist = matchlist,
    dataToAnalyze = dataToAnalyze,
    undetected = undetected,
    seqNumberCol = seqNumberCol+1
  )
  return(ret)
}
