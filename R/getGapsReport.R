
#' getGapsReport
#' Sluzy do zweryfikowania czy sa luki w fakturach
#' #'
#' @param data must be vector with invoice numbers
#'
#' @return data frames with gaps
#'
#'
#' @export
getGapsReport <- function(patternToMatch, data) {
  Luki = switch(
    patternToMatch,
    "^([A-Z_]+)[/-]([0-9]{2,4})[/-]([0-9]+)[/-]([0-9A-Z]+)$" = {
      data %>%
        select(TypFaktury = V2, NumerPorzadkowy = V4, Okres = V3, TypFaktury2 = V5) %>%
        mutate(NumerPorzadkowy = as.numeric(NumerPorzadkowy)) %>%
        group_by(TypFaktury, TypFaktury2) %>%
        arrange(TypFaktury, TypFaktury2, NumerPorzadkowy) -> Baza



      Baza %>%
        summarise(Min = min(NumerPorzadkowy, na.rm = T),
                  Max = max(NumerPorzadkowy, na.rm = T),
                  diffMinMax = Max - Min + 1,
                  Len = n(),
                  LiczbaBrakujacychFaktur = diffMinMax - Len
        ) -> DoSEQ

      Vec <- vector("list", length = nrow(DoSEQ))
      for (i in 1:nrow(DoSEQ)) {
        if (DoSEQ$diffMinMax[i]==DoSEQ$Len[i]) {
          Vec[[i]] <- tibble(TypFaktury = DoSEQ$TypFaktury[i],
                             TypFaktury2 = DoSEQ$TypFaktury2[i],
                             BrakujaceNumery = NA)
        } else {
          temp <-seq(from = DoSEQ$Min[i], to = DoSEQ$Max[i], by = 1)
          temp_Numbers <- Baza %>%
            filter(TypFaktury == DoSEQ$TypFaktury[i],
                   TypFaktury2 == DoSEQ$TypFaktury2[i]) %>%
            ungroup() %>%
            select(NumerPorzadkowy) %>%
            unlist() %>%
            unname()

          Vec[[i]] <- tibble(TypFaktury = DoSEQ$TypFaktury[i],
                             TypFaktury2 = DoSEQ$TypFaktury2[i],
                             BrakujaceNumery = setdiff(temp, temp_Numbers))
        }

      }

      Luki <- bind_rows(Vec)
      return(
        list(Baza = Baza,
             PodsumowanieNumerowFaktur = DoSEQ,
             Luki = Luki)
      )

    },
    "^([A-Z_]+)[/-]([0-9]+)[/-]([0-9]{2,4})[/-]([0-9A-Z]+)$" = {

      data %>%
        select(TypFaktury = V2, NumerPorzadkowy = V3, Okres = V4, TypFaktury2 = V5) %>%
        mutate(NumerPorzadkowy = as.numeric(NumerPorzadkowy)) %>%
        group_by(TypFaktury, TypFaktury2) %>%
        arrange(TypFaktury, TypFaktury2, NumerPorzadkowy) -> Baza



      Baza %>%
        summarise(Min = min(NumerPorzadkowy, na.rm = T),
                  Max = max(NumerPorzadkowy, na.rm = T),
                  diffMinMax = Max - Min + 1,
                  Len = n(),
                  LiczbaBrakujacychFaktur = diffMinMax - Len
        ) -> DoSEQ

      Vec <- vector("list", length = nrow(DoSEQ))
      for (i in 1:nrow(DoSEQ)) {
        if (DoSEQ$diffMinMax[i]==DoSEQ$Len[i]) {
          Vec[[i]] <- tibble(TypFaktury = DoSEQ$TypFaktury[i],
                                          TypFaktury2 = DoSEQ$TypFaktury2[i],
                                          BrakujaceNumery = NA)
        } else {
          temp <-seq(from = DoSEQ$Min[i], to = DoSEQ$Max[i], by = 1)
          temp_Numbers <- Baza %>%
            filter(TypFaktury == DoSEQ$TypFaktury[i],
                   TypFaktury2 == DoSEQ$TypFaktury2[i]) %>%
            ungroup() %>%
            select(NumerPorzadkowy) %>%
            unlist() %>%
            unname()

          Vec[[i]] <- tibble(TypFaktury = DoSEQ$TypFaktury[i],
                             TypFaktury2 = DoSEQ$TypFaktury2[i],
                             BrakujaceNumery = setdiff(temp, temp_Numbers))
        }

      }

      Luki <- bind_rows(Vec)
      return(
        list(Baza = Baza,
             PodsumowanieNumerowFaktur = DoSEQ,
             Luki = Luki)
      )

    },
    "^([A-Z_]+)[/-]([0-9]{2,4})[/-]([0-9]+)$" = {

      data %>%
        select(TypFaktury = V2, NumerPorzadkowy = V4, Okres = V3) %>%
        mutate(NumerPorzadkowy = as.numeric(NumerPorzadkowy)) %>%
        group_by(TypFaktury) %>%
        arrange(TypFaktury, NumerPorzadkowy) -> Baza



      Baza %>%
        summarise(Min = min(NumerPorzadkowy, na.rm = T),
                  Max = max(NumerPorzadkowy, na.rm = T),
                  diffMinMax = Max - Min + 1,
                  Len = n(),
                  LiczbaBrakujacychFaktur = diffMinMax - Len
        ) -> DoSEQ

      Vec <- vector("list", length = nrow(DoSEQ))
      for (i in 1:nrow(DoSEQ)) {
        if (DoSEQ$diffMinMax[i]==DoSEQ$Len[i]) {
          Vec[[i]] <- tibble(TypFaktury = DoSEQ$TypFaktury[i],
                             BrakujaceNumery = NA)
        } else {
          temp <-seq(from = DoSEQ$Min[i], to = DoSEQ$Max[i], by = 1)
          temp_Numbers <- Baza %>%
            filter(TypFaktury == DoSEQ$TypFaktury[i]
                   ) %>%
            ungroup() %>%
            select(NumerPorzadkowy) %>%
            unlist() %>%
            unname()

          Vec[[i]] <- tibble(TypFaktury = DoSEQ$TypFaktury[i],
                             BrakujaceNumery = setdiff(temp, temp_Numbers))
        }

      }

      Luki <- bind_rows(Vec)
      return(
        list(Baza = Baza,
             PodsumowanieNumerowFaktur = DoSEQ,
             Luki = Luki)
      )


    },
    "^([A-Z_]+)[/-]([0-9]+)[/-]([0-9]{2})[/-]([0-9]{2})[/-]([0-9]+)$" = {

      data %>%
        select(TypFaktury = V2, NumerPorzadkowy = V6, Okres = V5, TypFaktury2 = V3) %>%
        mutate(NumerPorzadkowy = as.numeric(NumerPorzadkowy)) %>%
        group_by(TypFaktury, TypFaktury2) %>%
        arrange(TypFaktury, TypFaktury2, NumerPorzadkowy) -> Baza



      Baza %>%
        summarise(Min = min(NumerPorzadkowy, na.rm = T),
                  Max = max(NumerPorzadkowy, na.rm = T),
                  diffMinMax = Max - Min + 1,
                  Len = n(),
                  LiczbaBrakujacychFaktur = diffMinMax - Len
        ) -> DoSEQ

      Vec <- vector("list", length = nrow(DoSEQ))
      for (i in 1:nrow(DoSEQ)) {
        if (DoSEQ$diffMinMax[i]==DoSEQ$Len[i]) {
          Vec[[i]] <- tibble(TypFaktury = DoSEQ$TypFaktury[i],
                             TypFaktury2 = DoSEQ$TypFaktury2[i],
                             BrakujaceNumery = NA)
        } else {
          temp <-seq(from = DoSEQ$Min[i], to = DoSEQ$Max[i], by = 1)
          temp_Numbers <- Baza %>%
            filter(TypFaktury == DoSEQ$TypFaktury[i],
                   TypFaktury2 == DoSEQ$TypFaktury2[i]) %>%
            ungroup() %>%
            select(NumerPorzadkowy) %>%
            unlist() %>%
            unname()

          Vec[[i]] <- tibble(TypFaktury = DoSEQ$TypFaktury[i],
                             TypFaktury2 = DoSEQ$TypFaktury2[i],
                             BrakujaceNumery = setdiff(temp, temp_Numbers))
        }

      }

      Luki <- bind_rows(Vec)
      return(
        list(Baza = Baza,
             PodsumowanieNumerowFaktur = DoSEQ,
             Luki = Luki)
      )


    },

    "^[0-9]+$" = {

      data %>%
        select(NumerPorzadkowy = V1) %>%
        mutate(NumerPorzadkowy = as.numeric(NumerPorzadkowy)) %>%
        arrange( NumerPorzadkowy) -> Baza

      Baza %>%
        summarise(Min = min(NumerPorzadkowy, na.rm = T),
                  Max = max(NumerPorzadkowy, na.rm = T),
                  diffMinMax = Max - Min + 1,
                  Len = n(),
                  LiczbaBrakujacychFaktur = diffMinMax - Len
        ) -> DoSEQ

      Vec <- vector("list", length = nrow(DoSEQ))
      for (i in 1:nrow(DoSEQ)) {
        if (DoSEQ$diffMinMax[i]==DoSEQ$Len[i]) {
          Vec[[i]] <- tibble(BrakujaceNumery = NA)
        } else {
          temp <-seq(from = DoSEQ$Min[i], to = DoSEQ$Max[i], by = 1)
          temp_Numbers <- Baza %>%
            ungroup() %>%
            select(NumerPorzadkowy) %>%
            unlist() %>%
            unname()


          Vec[[i]] <- tibble(BrakujaceNumery = setdiff(temp, temp_Numbers))
        }

      }

      Luki <- bind_rows(Vec)
      return(
        list(Baza = Baza,
             PodsumowanieNumerowFaktur = DoSEQ,
             Luki = Luki)
      )

    }
  )

  return(Luki)

}
