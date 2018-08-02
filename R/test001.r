
#' test001 Służy do obliczenia sum kontrolnych.
#'
#' @param data must be converted to numeric data.frame with JPK FA, or JPK_VAT
#'
#' @return a tibble with some metric: sum, median, mean and etc..
#' @export
#'
#' @examples
test001 <- function(data) {

  data %>%
    summarise(Razem = n()) %>%
    mutate(Metric = "Liczba wierszy: ") -> LiczbaWierszy


  data %>%
    summarise_if(is.numeric, sum, na.rm = T) %>%
    mutate(Metric = "Sumy: ") %>%
    select(Metric, everything()) -> Sumy

  data %>%
    summarise_if(is.numeric, min, na.rm = T) %>%
    mutate(Metric = "Min: ") %>%
    select(Metric, everything()) -> Min

  data %>%
    summarise_if(is.numeric, max, na.rm = T) %>%
    mutate(Metric = "Max: ") %>%
    select(Metric, everything()) -> Max

  data %>%
    summarise_if(is.numeric, median, na.rm = T) %>%
    mutate(Metric = "Median: ") %>%
    select(Metric, everything()) -> Median

  data %>%
    summarise_if(is.numeric, quantile, probs = 0.025, na.rm = T) %>%
    mutate(Metric = "Q025: ") %>%
    select(Metric, everything()) -> Q025

  data %>%
    summarise_if(is.numeric, quantile, probs = 0.25, na.rm = T) %>%
    mutate(Metric = "Q25: ") %>%
    select(Metric, everything()) -> Q25

  data %>%
    summarise_if(is.numeric, quantile, probs = 0.75, na.rm = T) %>%
    mutate(Metric = "Q75: ") %>%
    select(Metric, everything()) -> Q75

  data %>%
    summarise_if(is.numeric, quantile, probs = 0.975, na.rm = T) %>%
    mutate(Metric = "Q975: ") %>%
    select(Metric, everything()) -> Q975

  data %>%
    apply(FUN = function(x) {return(sum(is.na(x)))}, 2) %>%
    t() %>%
    as.tibble() %>%
    bind_cols(tibble(Metric = "NA")) %>%
    select(Metric, everything()) ->  Empty

  ret <- list(typeOfExport = "list",
              whichIndexesExport = c(3),
              summary = bind_rows(Sumy, Min, Max, Median, Q025, Q25, Q75, Q975, Empty, LiczbaWierszy)

  )
  return(ret)

}
